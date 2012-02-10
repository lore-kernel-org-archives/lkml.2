Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2BJEsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 23:48:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56662 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548Ab2BJEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 23:48:11 -0500
Date: Fri, 10 Feb 2012 15:48:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        =?UTF-8?B?VsOtY3Rvcg==?= Manuel =?UTF-8?B?SsOhcXVleg==?= Leal 
	<vjaquez@igalia.com>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20120210154806.4a81ec53dc24a40cf91a758a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Feb_2012_15_48_06_+1100_h6deTF/4mN_prhb6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Feb_2012_15_48_06_+1100_h6deTF/4mN_prhb6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/tidspbridge/rmgr/drv_interface.c between commit
5a63177a6967 ("staging: tidspbridge: fix bridge_open memory leaks") from
Linus' tree and commit 518761dba127 ("staging: tidspbridge: remove unused
header") from the staging tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/tidspbridge/rmgr/drv_interface.c
index 385740b,31b5140..0000000
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@@ -131,7 -117,157 +117,166 @@@ MODULE_AUTHOR("Texas Instruments")
  MODULE_LICENSE("GPL");
  MODULE_VERSION(DSPBRIDGE_VERSION);
 =20
- static char *driver_name =3D DRIVER_NAME;
+ /*
+  * This function is called when an application opens handle to the
+  * bridge driver.
+  */
+ static int bridge_open(struct inode *ip, struct file *filp)
+ {
+ 	int status =3D 0;
+ 	struct process_context *pr_ctxt =3D NULL;
+=20
+ 	/*
+ 	 * Allocate a new process context and insert it into global
+ 	 * process context list.
+ 	 */
+=20
+ #ifdef CONFIG_TIDSPBRIDGE_RECOVERY
+ 	if (recover) {
+ 		if (filp->f_flags & O_NONBLOCK ||
+ 		    wait_for_completion_interruptible(&bridge_open_comp))
+ 			return -EBUSY;
+ 	}
+ #endif
+ 	pr_ctxt =3D kzalloc(sizeof(struct process_context), GFP_KERNEL);
 -	if (pr_ctxt) {
 -		pr_ctxt->res_state =3D PROC_RES_ALLOCATED;
 -		spin_lock_init(&pr_ctxt->dmm_map_lock);
 -		INIT_LIST_HEAD(&pr_ctxt->dmm_map_list);
 -		spin_lock_init(&pr_ctxt->dmm_rsv_lock);
 -		INIT_LIST_HEAD(&pr_ctxt->dmm_rsv_list);
 -
 -		pr_ctxt->node_id =3D kzalloc(sizeof(struct idr), GFP_KERNEL);
 -		if (pr_ctxt->node_id) {
 -			idr_init(pr_ctxt->node_id);
 -		} else {
 -			status =3D -ENOMEM;
 -			goto err;
 -		}
++	if (!pr_ctxt)
++		return -ENOMEM;
++
++	pr_ctxt->res_state =3D PROC_RES_ALLOCATED;
++	spin_lock_init(&pr_ctxt->dmm_map_lock);
++	INIT_LIST_HEAD(&pr_ctxt->dmm_map_list);
++	spin_lock_init(&pr_ctxt->dmm_rsv_lock);
++	INIT_LIST_HEAD(&pr_ctxt->dmm_rsv_list);
+=20
 -		pr_ctxt->stream_id =3D kzalloc(sizeof(struct idr), GFP_KERNEL);
 -		if (pr_ctxt->stream_id)
 -			idr_init(pr_ctxt->stream_id);
 -		else
 -			status =3D -ENOMEM;
 -	} else {
++	pr_ctxt->node_id =3D kzalloc(sizeof(struct idr), GFP_KERNEL);
++	if (!pr_ctxt->node_id) {
+ 		status =3D -ENOMEM;
++		goto err1;
+ 	}
 -err:
++
++	idr_init(pr_ctxt->node_id);
++
++	pr_ctxt->stream_id =3D kzalloc(sizeof(struct idr), GFP_KERNEL);
++	if (!pr_ctxt->stream_id) {
++		status =3D -ENOMEM;
++		goto err2;
++	}
++
++	idr_init(pr_ctxt->stream_id);
++
+ 	filp->private_data =3D pr_ctxt;
++
+ #ifdef CONFIG_TIDSPBRIDGE_RECOVERY
 -	if (!status)
 -		atomic_inc(&bridge_cref);
++	atomic_inc(&bridge_cref);
+ #endif
++	return 0;
++
++err2:
++	kfree(pr_ctxt->node_id);
++err1:
++	kfree(pr_ctxt);
+ 	return status;
+ }
+=20
+ /*
+  * This function is called when an application closes handle to the bridge
+  * driver.
+  */
+ static int bridge_release(struct inode *ip, struct file *filp)
+ {
+ 	int status =3D 0;
+ 	struct process_context *pr_ctxt;
+=20
+ 	if (!filp->private_data) {
+ 		status =3D -EIO;
+ 		goto err;
+ 	}
+=20
+ 	pr_ctxt =3D filp->private_data;
+ 	flush_signals(current);
+ 	drv_remove_all_resources(pr_ctxt);
+ 	proc_detach(pr_ctxt);
++	kfree(pr_ctxt->node_id);
++	kfree(pr_ctxt->stream_id);
+ 	kfree(pr_ctxt);
+=20
+ 	filp->private_data =3D NULL;
+=20
+ err:
+ #ifdef CONFIG_TIDSPBRIDGE_RECOVERY
+ 	if (!atomic_dec_return(&bridge_cref))
+ 		complete(&bridge_comp);
+ #endif
+ 	return status;
+ }
+=20
+ /* This function provides IO interface to the bridge driver. */
+ static long bridge_ioctl(struct file *filp, unsigned int code,
+ 			 unsigned long args)
+ {
+ 	int status;
+ 	u32 retval =3D 0;
+ 	union trapped_args buf_in;
+=20
+ #ifdef CONFIG_TIDSPBRIDGE_RECOVERY
+ 	if (recover) {
+ 		status =3D -EIO;
+ 		goto err;
+ 	}
+ #endif
+ #ifdef CONFIG_PM
+ 	status =3D omap34_xxbridge_suspend_lockout(&bridge_suspend_data, filp);
+ 	if (status !=3D 0)
+ 		return status;
+ #endif
+=20
+ 	if (!filp->private_data) {
+ 		status =3D -EIO;
+ 		goto err;
+ 	}
+=20
+ 	status =3D copy_from_user(&buf_in, (union trapped_args *)args,
+ 				sizeof(union trapped_args));
+=20
+ 	if (!status) {
+ 		status =3D api_call_dev_ioctl(code, &buf_in, &retval,
+ 					    filp->private_data);
+=20
+ 		if (!status) {
+ 			status =3D retval;
+ 		} else {
+ 			dev_dbg(bridge, "%s: IOCTL Failed, code: 0x%x "
+ 				"status 0x%x\n", __func__, code, status);
+ 			status =3D -1;
+ 		}
+=20
+ 	}
+=20
+ err:
+ 	return status;
+ }
+=20
+ /* This function maps kernel space memory to user space memory. */
+ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
+ {
+ 	u32 status;
+=20
+ 	vma->vm_flags |=3D VM_RESERVED | VM_IO;
+ 	vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
+=20
+ 	dev_dbg(bridge, "%s: vm filp %p start %lx end %lx page_prot %ulx "
+ 		"flags %lx\n", __func__, filp,
+ 		vma->vm_start, vma->vm_end, vma->vm_page_prot,
+ 		vma->vm_flags);
+=20
+ 	status =3D remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+ 				 vma->vm_end - vma->vm_start,
+ 				 vma->vm_page_prot);
+ 	if (status !=3D 0)
+ 		status =3D -EAGAIN;
+=20
+ 	return status;
+ }
 =20
  static const struct file_operations bridge_fops =3D {
  	.open =3D bridge_open,
@@@ -405,14 -540,10 +549,13 @@@ static int __devexit omap34_xx_bridge_r
 =20
  	if (driver_context) {
  		/* Put the DSP in reset state */
- 		ret =3D dsp_deinit(driver_context);
+ 		dsp_deinit(driver_context);
  		driver_context =3D 0;
- 		DBC_ASSERT(ret =3D=3D true);
  	}
 =20
 +	kfree(drv_datap);
 +	dev_set_drvdata(bridge, NULL);
 +
  func_cont:
  	mem_ext_phys_pool_release();
 =20

--Signature=_Fri__10_Feb_2012_15_48_06_+1100_h6deTF/4mN_prhb6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPNKGGAAoJEECxmPOUX5FEn5QP/A9sD3D+ZW5rilO/YEYgjQSY
v6FM9v0u1ovex6vAo4tU/4vIxzWdfJnjIYp6YVjWuA1kdsnPr2LKCKVadVbMXjl0
jqMogXoLEevX7RjbFRpnhWPjBf5p9/7nv+noydmSl9NG+8pFLarQ+vUDyrPq/Ofz
9thB2xWgNy7hh+mjp7iPccyiAzs4jDfjESkXDwB2lf9yyTcwRsClpGJxtyOSkt5K
pUspD70YiqdtDfCYVxV4YfDkoCr+nrkqHP6ncxRxsTwrJBsI8+Y2bWje4c8TanLn
UemLp5/MGYKXAYVITu/kBrO2aEctGayQenbo4ObZvKFpc2InQX8A+iRiXTOdr9qi
Uif9faH3/T1h0A0062qwcP+dxSKOcLzF6EiWuoys1bvz5blv0gj4b3lKIZPvhvoI
rQuK/AfWDQEr6+YbB0fQMsDEtyRHRPkodUpIiN26wqOLqpy2KN5JItWC/+5CSST5
RfD0nj9tLeaIEK6S4n0zClufs6+qYvoS5mp0CvjMzyRvwQNLIHwaHK+C5UjdelpE
Ca5fiKduEIKxMXSgDUWYKH6cKy8cuv2T5uZcT/zlNX7MsFO/9rhXF8e7I1v4TJwS
tfXddtcIf8c0f2SCxkU/egZUShXSAYH/pDpIoPBnb3FI4gqf0nB25bFxH06wPo62
nQYjR6QR+xnSvC1AYO7v
=kHXy
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Feb_2012_15_48_06_+1100_h6deTF/4mN_prhb6--
