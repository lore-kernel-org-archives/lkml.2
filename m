Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1JPXDJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 19:03:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44379 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751058Ab1JPXDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 19:03:08 -0400
Message-ID: <1318806187.1985.23.camel@Joe-Laptop>
Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
 staging
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, dmitry.torokhov@gmail.com,
        Haiyang Zhang <haiyangz@microsoft.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
        linux-input@vger.kernel.org, devel@linuxdriverproject.org
Date: Sun, 16 Oct 2011 16:03:07 -0700
In-Reply-To: <20111016222847.GM18470@longonot.mountain>
References: <1318658907-16698-1-git-send-email-kys@microsoft.com>
	 <1318660596.6035.27.camel@Joe-Laptop>
	 <20111016222847.GM18470@longonot.mountain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 01:28 +0300, Dan Carpenter wrote:
> On Fri, Oct 14, 2011 at 11:36:36PM -0700, Joe Perches wrote:
[]
> > 	case 0:
> > 		if (bytes_recvd <= 0)
> > 			goto loop;
> In the original we called break here (which is equivelent to a
> return).  Btw setting a stack variable and then returning immediately
> like the original code did is pointless.

OK, return it is.

Perhaps this is better.  (two of the breaks could be goto loop)

I did add a couple of checks to make sure kmalloc'd
memory was always freed.

Another possible simplification is to always use kmalloc
instead of using stack and/or kmalloc.

static void mousevsc_on_channel_callback(void *context)
{
	static const int packetSize = 0x100;
	unsigned char packet[packetSize];
	int ret;
	struct hv_device *device = (struct hv_device *)context;
	u32 bytes_recvd;
	u64 req_id;
	struct vmpacket_descriptor *desc;
	unsigned char *buffer = packet;
	int bufferlen = packetSize;
	bool malloced =  false;

loop:
	ret = vmbus_bus_recvpacket_raw(device->channel, buffer, bufferlen,
				       &bytes_recvd, &req_id);
	switch (ret) {
	case -ENOBUFS:		/* Handle large packet */

		if (malloced)	/* Maybe repeated -ENOBUFS ? */
			kfree(buffer);

		bufferlen = bytes_recvd;
		buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
		if (!buffer)
			return;
		malloced = true;
		break;

	case 0:
		if (bytes_recvd <= 0) {
			if (malloced)
				kfree(buffer);
			return;
		}

		desc = (struct vmpacket_descriptor *)buffer;

		switch (desc->type) {
		case VM_PKT_DATA_INBAND:
			mousevsc_on_receive(device, desc);
			break;
		default:
			pr_err("unhandled packet type %d, tid %llx len %d\n",
			       desc->type, req_id, bytes_recvd);
			break;
		}
		/* reset to original buffers */
		if (malloced) {
			kfree(buffer);
			malloced = false;
			buffer = packet;
			bufferlen = packetSize;
		}
		break;
	}

	goto loop;
}


