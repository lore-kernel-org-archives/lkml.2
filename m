Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab2BMFId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:08:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52459 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2BMFIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:08:31 -0500
Date: Mon, 13 Feb 2012 16:08:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the kmap_atomic tree with the staging
 tree
Message-Id: <20120213160821.e223fac74fb6fa53315f3dbe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_16_08_21_+1100_aY5V3xlsLoj83A1S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Feb_2012_16_08_21_+1100_aY5V3xlsLoj83A1S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cong,

Today's linux-next merge of the kmap_atomic tree got a conflict in
drivers/staging/hv/storvsc_drv.c between various commits from the staging
tree and commit c41a603a7235 ("hv: remove the second argument of k
[un]map_atomic()") from the kmap_atomic tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/hv/storvsc_drv.c
index 695ffc3,ddbdec8..0000000
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@@ -408,339 -398,113 +408,335 @@@ get_in_err
 =20
  }
 =20
 -static int storvsc_channel_init(struct hv_device *device)
 +static void destroy_bounce_buffer(struct scatterlist *sgl,
 +				  unsigned int sg_count)
  {
 -	struct storvsc_device *stor_device;
 -	struct hv_storvsc_request *request;
 -	struct vstor_packet *vstor_packet;
 -	int ret, t;
 +	int i;
 +	struct page *page_buf;
 =20
 -	stor_device =3D get_out_stor_device(device);
 -	if (!stor_device)
 -		return -ENODEV;
 +	for (i =3D 0; i < sg_count; i++) {
 +		page_buf =3D sg_page((&sgl[i]));
 +		if (page_buf !=3D NULL)
 +			__free_page(page_buf);
 +	}
 =20
 -	request =3D &stor_device->init_request;
 -	vstor_packet =3D &request->vstor_packet;
 +	kfree(sgl);
 +}
 =20
 -	/*
 -	 * Now, initiate the vsc/vsp initialization protocol on the open
 -	 * channel
 -	 */
 -	memset(request, 0, sizeof(struct hv_storvsc_request));
 -	init_completion(&request->wait_event);
 -	vstor_packet->operation =3D VSTOR_OPERATION_BEGIN_INITIALIZATION;
 -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
 +static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_coun=
t)
 +{
 +	int i;
 =20
 -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
 -			       sizeof(struct vstor_packet),
 -			       (unsigned long)request,
 -			       VM_PKT_DATA_INBAND,
 -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 -	if (ret !=3D 0)
 -		goto cleanup;
 +	/* No need to check */
 +	if (sg_count < 2)
 +		return -1;
 =20
 -	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 -	if (t =3D=3D 0) {
 -		ret =3D -ETIMEDOUT;
 -		goto cleanup;
 +	/* We have at least 2 sg entries */
 +	for (i =3D 0; i < sg_count; i++) {
 +		if (i =3D=3D 0) {
 +			/* make sure 1st one does not have hole */
 +			if (sgl[i].offset + sgl[i].length !=3D PAGE_SIZE)
 +				return i;
 +		} else if (i =3D=3D sg_count - 1) {
 +			/* make sure last one does not have hole */
 +			if (sgl[i].offset !=3D 0)
 +				return i;
 +		} else {
 +			/* make sure no hole in the middle */
 +			if (sgl[i].length !=3D PAGE_SIZE || sgl[i].offset !=3D 0)
 +				return i;
 +		}
  	}
 +	return -1;
 +}
 =20
 -	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
 -	    vstor_packet->status !=3D 0)
 -		goto cleanup;
 -
 -
 -	/* reuse the packet for version range supported */
 -	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 -	vstor_packet->operation =3D VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
 -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
 +static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 +						unsigned int sg_count,
 +						unsigned int len,
 +						int write)
 +{
 +	int i;
 +	int num_pages;
 +	struct scatterlist *bounce_sgl;
 +	struct page *page_buf;
 +	unsigned int buf_len =3D ((write =3D=3D WRITE_TYPE) ? 0 : PAGE_SIZE);
 =20
 -	vstor_packet->version.major_minor =3D VMSTOR_PROTOCOL_VERSION_CURRENT;
 -	FILL_VMSTOR_REVISION(vstor_packet->version.revision);
 +	num_pages =3D ALIGN(len, PAGE_SIZE) >> PAGE_SHIFT;
 =20
 -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
 -			       sizeof(struct vstor_packet),
 -			       (unsigned long)request,
 -			       VM_PKT_DATA_INBAND,
 -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 -	if (ret !=3D 0)
 -		goto cleanup;
 +	bounce_sgl =3D kcalloc(num_pages, sizeof(struct scatterlist), GFP_ATOMIC=
);
 +	if (!bounce_sgl)
 +		return NULL;
 =20
 -	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 -	if (t =3D=3D 0) {
 -		ret =3D -ETIMEDOUT;
 -		goto cleanup;
 +	for (i =3D 0; i < num_pages; i++) {
 +		page_buf =3D alloc_page(GFP_ATOMIC);
 +		if (!page_buf)
 +			goto cleanup;
 +		sg_set_page(&bounce_sgl[i], page_buf, buf_len, 0);
  	}
 =20
 -	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
 -	    vstor_packet->status !=3D 0)
 -		goto cleanup;
 +	return bounce_sgl;
 =20
 +cleanup:
 +	destroy_bounce_buffer(bounce_sgl, num_pages);
 +	return NULL;
 +}
 =20
 -	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 -	vstor_packet->operation =3D VSTOR_OPERATION_QUERY_PROPERTIES;
 -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
 -	vstor_packet->storage_channel_properties.port_number =3D
 -					stor_device->port_number;
 +/* Assume the original sgl has enough room */
 +static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 +					    struct scatterlist *bounce_sgl,
 +					    unsigned int orig_sgl_count,
 +					    unsigned int bounce_sgl_count)
 +{
 +	int i;
 +	int j =3D 0;
 +	unsigned long src, dest;
 +	unsigned int srclen, destlen, copylen;
 +	unsigned int total_copied =3D 0;
 +	unsigned long bounce_addr =3D 0;
 +	unsigned long dest_addr =3D 0;
 +	unsigned long flags;
 =20
 -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
 -			       sizeof(struct vstor_packet),
 -			       (unsigned long)request,
 -			       VM_PKT_DATA_INBAND,
 -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 +	local_irq_save(flags);
 =20
 -	if (ret !=3D 0)
 -		goto cleanup;
 +	for (i =3D 0; i < orig_sgl_count; i++) {
- 		dest_addr =3D (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
- 					KM_IRQ0) + orig_sgl[i].offset;
++		dest_addr =3D (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
++					+ orig_sgl[i].offset;
 +		dest =3D dest_addr;
 +		destlen =3D orig_sgl[i].length;
 =20
 -	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 -	if (t =3D=3D 0) {
 -		ret =3D -ETIMEDOUT;
 -		goto cleanup;
 -	}
 +		if (bounce_addr =3D=3D 0)
 +			bounce_addr =3D
- 			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])),
- 							KM_IRQ0);
++			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])));
 =20
 -	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
 -	    vstor_packet->status !=3D 0)
 -		goto cleanup;
 +		while (destlen) {
 +			src =3D bounce_addr + bounce_sgl[j].offset;
 +			srclen =3D bounce_sgl[j].length - bounce_sgl[j].offset;
 =20
 -	stor_device->path_id =3D vstor_packet->storage_channel_properties.path_i=
d;
 -	stor_device->target_id
 -		=3D vstor_packet->storage_channel_properties.target_id;
 +			copylen =3D min(srclen, destlen);
 +			memcpy((void *)dest, (void *)src, copylen);
 =20
 -	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 -	vstor_packet->operation =3D VSTOR_OPERATION_END_INITIALIZATION;
 -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
 +			total_copied +=3D copylen;
 +			bounce_sgl[j].offset +=3D copylen;
 +			destlen -=3D copylen;
 +			dest +=3D copylen;
 =20
 -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
 -			       sizeof(struct vstor_packet),
 -			       (unsigned long)request,
 -			       VM_PKT_DATA_INBAND,
 -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 +			if (bounce_sgl[j].offset =3D=3D bounce_sgl[j].length) {
 +				/* full */
- 				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
++				kunmap_atomic((void *)bounce_addr);
 +				j++;
 +
 +				/*
 +				 * It is possible that the number of elements
 +				 * in the bounce buffer may not be equal to
 +				 * the number of elements in the original
 +				 * scatter list. Handle this correctly.
 +				 */
 +
 +				if (j =3D=3D bounce_sgl_count) {
 +					/*
 +					 * We are done; cleanup and return.
 +					 */
 +					kunmap_atomic((void *)(dest_addr -
- 							orig_sgl[i].offset),
- 							KM_IRQ0);
++							orig_sgl[i].offset));
 +					local_irq_restore(flags);
 +					return total_copied;
 +				}
 +
 +				/* if we need to use another bounce buffer */
 +				if (destlen || i !=3D orig_sgl_count - 1)
 +					bounce_addr =3D
 +					(unsigned long)kmap_atomic(
- 					sg_page((&bounce_sgl[j])), KM_IRQ0);
++					sg_page((&bounce_sgl[j])));
 +			} else if (destlen =3D=3D 0 && i =3D=3D orig_sgl_count - 1) {
 +				/* unmap the last bounce that is < PAGE_SIZE */
- 				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
++				kunmap_atomic((void *)bounce_addr);
 +			}
 +		}
 +
- 		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset),
- 			      KM_IRQ0);
++		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset));
 +	}
 +
 +	local_irq_restore(flags);
 +
 +	return total_copied;
 +}
 +
 +/* Assume the bounce_sgl has enough room ie using the create_bounce_buffe=
r() */
 +static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 +					  struct scatterlist *bounce_sgl,
 +					  unsigned int orig_sgl_count)
 +{
 +	int i;
 +	int j =3D 0;
 +	unsigned long src, dest;
 +	unsigned int srclen, destlen, copylen;
 +	unsigned int total_copied =3D 0;
 +	unsigned long bounce_addr =3D 0;
 +	unsigned long src_addr =3D 0;
 +	unsigned long flags;
 +
 +	local_irq_save(flags);
 +
 +	for (i =3D 0; i < orig_sgl_count; i++) {
- 		src_addr =3D (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
- 				KM_IRQ0) + orig_sgl[i].offset;
++		src_addr =3D (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
++				+ orig_sgl[i].offset;
 +		src =3D src_addr;
 +		srclen =3D orig_sgl[i].length;
 +
 +		if (bounce_addr =3D=3D 0)
 +			bounce_addr =3D
- 			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])),
- 						KM_IRQ0);
++			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])));
 +
 +		while (srclen) {
 +			/* assume bounce offset always =3D=3D 0 */
 +			dest =3D bounce_addr + bounce_sgl[j].length;
 +			destlen =3D PAGE_SIZE - bounce_sgl[j].length;
 +
 +			copylen =3D min(srclen, destlen);
 +			memcpy((void *)dest, (void *)src, copylen);
 +
 +			total_copied +=3D copylen;
 +			bounce_sgl[j].length +=3D copylen;
 +			srclen -=3D copylen;
 +			src +=3D copylen;
 +
 +			if (bounce_sgl[j].length =3D=3D PAGE_SIZE) {
 +				/* full..move to next entry */
- 				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
++				kunmap_atomic((void *)bounce_addr);
 +				j++;
 +
 +				/* if we need to use another bounce buffer */
 +				if (srclen || i !=3D orig_sgl_count - 1)
 +					bounce_addr =3D
 +					(unsigned long)kmap_atomic(
- 					sg_page((&bounce_sgl[j])), KM_IRQ0);
++					sg_page((&bounce_sgl[j])));
 +
 +			} else if (srclen =3D=3D 0 && i =3D=3D orig_sgl_count - 1) {
 +				/* unmap the last bounce that is < PAGE_SIZE */
- 				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
++				kunmap_atomic((void *)bounce_addr);
 +			}
 +		}
 +
- 		kunmap_atomic((void *)(src_addr - orig_sgl[i].offset), KM_IRQ0);
++		kunmap_atomic((void *)(src_addr - orig_sgl[i].offset));
 +	}
 +
 +	local_irq_restore(flags);
 +
 +	return total_copied;
 +}
 +
 +static int storvsc_channel_init(struct hv_device *device)
 +{
 +	struct storvsc_device *stor_device;
 +	struct storvsc_cmd_request *request;
 +	struct vstor_packet *vstor_packet;
 +	int ret, t;
 +
 +	stor_device =3D get_out_stor_device(device);
 +	if (!stor_device)
 +		return -ENODEV;
 +
 +	request =3D &stor_device->init_request;
 +	vstor_packet =3D &request->vstor_packet;
 +
 +	/*
 +	 * Now, initiate the vsc/vsp initialization protocol on the open
 +	 * channel
 +	 */
 +	memset(request, 0, sizeof(struct storvsc_cmd_request));
 +	init_completion(&request->wait_event);
 +	vstor_packet->operation =3D VSTOR_OPERATION_BEGIN_INITIALIZATION;
 +	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
 +
 +	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
 +			       sizeof(struct vstor_packet),
 +			       (unsigned long)request,
 +			       VM_PKT_DATA_INBAND,
 +			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 +	if (ret !=3D 0)
 +		goto cleanup;
 +
 +	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 +	if (t =3D=3D 0) {
 +		ret =3D -ETIMEDOUT;
 +		goto cleanup;
 +	}
 +
 +	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
 +	    vstor_packet->status !=3D 0)
 +		goto cleanup;
 +
 +
 +	/* reuse the packet for version range supported */
 +	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 +	vstor_packet->operation =3D VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
 +	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
 +
 +	vstor_packet->version.major_minor =3D
 +		storvsc_get_version(VMSTOR_CURRENT_MAJOR, VMSTOR_CURRENT_MINOR);
 +
 +	/*
 +	 * The revision number is only used in Windows; set it to 0.
 +	 */
 +	vstor_packet->version.revision =3D 0;
 +
 +	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
 +			       sizeof(struct vstor_packet),
 +			       (unsigned long)request,
 +			       VM_PKT_DATA_INBAND,
 +			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 +	if (ret !=3D 0)
 +		goto cleanup;
 +
 +	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 +	if (t =3D=3D 0) {
 +		ret =3D -ETIMEDOUT;
 +		goto cleanup;
 +	}
 +
 +	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
 +	    vstor_packet->status !=3D 0)
 +		goto cleanup;
 +
 +
 +	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 +	vstor_packet->operation =3D VSTOR_OPERATION_QUERY_PROPERTIES;
 +	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
 +	vstor_packet->storage_channel_properties.port_number =3D
 +					stor_device->port_number;
 +
 +	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
 +			       sizeof(struct vstor_packet),
 +			       (unsigned long)request,
 +			       VM_PKT_DATA_INBAND,
 +			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 +
 +	if (ret !=3D 0)
 +		goto cleanup;
 +
 +	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 +	if (t =3D=3D 0) {
 +		ret =3D -ETIMEDOUT;
 +		goto cleanup;
 +	}
 +
 +	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
 +	    vstor_packet->status !=3D 0)
 +		goto cleanup;
 +
 +	stor_device->path_id =3D vstor_packet->storage_channel_properties.path_i=
d;
 +	stor_device->target_id
 +		=3D vstor_packet->storage_channel_properties.target_id;
 +
 +	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 +	vstor_packet->operation =3D VSTOR_OPERATION_END_INITIALIZATION;
 +	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
 +
 +	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
 +			       sizeof(struct vstor_packet),
 +			       (unsigned long)request,
 +			       VM_PKT_DATA_INBAND,
 +			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 =20
  	if (ret !=3D 0)
  		goto cleanup;

--Signature=_Mon__13_Feb_2012_16_08_21_+1100_aY5V3xlsLoj83A1S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOJrFAAoJEECxmPOUX5FE3lEQAIebqIDM4NihRlYS4FHsxQ3y
toHM1LEbsBDlnSjWqTq4Ell8DcW2MZnojZPCCWe1Fvc/3NRe4KF57/z2lWl5G41l
VDoXmWRWMHeQbmgmAareeOtF29J4K+oDihb2yI8rWSkUQMNFQy3XaI8xdz3/1lq4
gVlaQ2x3E7GwxNVvTfGSMy6Bn7/cJdAf/v+6hEZRHQe2f8oSi9bapJBiy25q+vbx
aMtFL70IVbf6Bd+bUQRA6gEvV/lN8Ua6CC4glbQLsHdwScrUsWZ3wHSfN6WxxuXM
3QAKeXSni/OgHDAGD2QbGIuM3LFyihjgrVOQ5qr5W+/qq81p5ZTOjOfXHQn/x25V
om7I3Yjj9OVxwOvB8sDdGNW+HNnyGp3ABxIWGkFmQ21vPL2ZOuErRO13MV/+lCfl
cyycEcJ/LCCpz6DJcIrtsImI/S2RFe7Vlru96r9BEismc0ZBDx8D/TAVD8BnpVza
Na0g5BsGLKul1WgjIizJ55fZ+UENS8eRLhtmNRWGlK3ptJzf7ZwsWMY0EWXlVG/n
pInP3zXcdQ8kX0iRznLlyEdcr+aDrGlfC5YVKN7SPnHmnz+JjrBeXT42nIGhQYAV
TB6V5d653qbjapmGGt4ScNIyaaLVdhzR8oS6IRy8Hgw3TCLGcloozC+bYsxnESgS
LCms1gKSLWwvjneNp+Rm
=m8wg
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_16_08_21_+1100_aY5V3xlsLoj83A1S--
