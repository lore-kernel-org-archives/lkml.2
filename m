Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab0KLSIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:08:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51420 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab0KLSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:08:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BWysOfeydAU4PcqKj8cg5ey/BgI7NqHPW5vK/mIJK5fRoX92iRTYMVXOLw7nICvO/i
         vxX77HVQGp3uJiJnBakgEN/elxyDf74dUxmpfJ8/hocvERAW3AFL+Q+hd5Qpt4Q+Xhr4
         a8YPhzUx3oyUvtzx/D2RfjqO1koNyl407f5I8=
Date: Fri, 12 Nov 2010 21:08:45 +0300
From: Vasiliy Kulikov <segooon@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Alex Chiang <achiang@hp.com>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infiniband: core: fix information leak to userland
Message-ID: <20101112180844.GA11533@albatros>
References: <1289054481-18145-1-git-send-email-segooon@gmail.com>
 <ada39r8ohiz.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada39r8ohiz.fsf@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 16:01 -0800, Roland Dreier wrote:
>  > Structure ib_uverbs_qp_attr is copied to userland with allmost all
>  > fields uninitialized (140 bytes on x86).  It leads to leaking of
>  > contents of kernel stack memory.
> 
> I don't think most of the fields are uninitialized... we have:
> 
>  	memset(&qp_attr, 0, sizeof qp_attr);
> 
> and then later on,
> 
> 	ib_copy_qp_attr_to_user(&resp, &qp_attr);

Uh, sorry, I was over-pessimistic here...

> which actually does initialize almost all of the fields in resp.  The
> things that are missing are clearing out the reserved fields in the
> structures, and also resp.qp_state never gets set.
> 
> I would suggest adding code to clear the reserved fields of structures
> to ib_copy_qp_attr_to_user() and ib_copy_ah_attr_to_user(), since this
> will fix what looks to be the same problem in ucma_init_qp_attr() (in
> drivers/infiniband/core/ucma.c).


Also part of grh field and ib_uverbs_ah_attr->reserved.  How do you see
this variant of zeroing?  (I don't know whether these fields may be
needed for another callers.)

diff --git a/drivers/infiniband/core/ucm.c
b/drivers/infiniband/core/ucm.c
index 08f948d..f7256f3 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -629,6 +629,7 @@ static ssize_t ib_ucm_init_qp_attr(struct ib_ucm_file *file,
        if (result)
                goto out;
 
+       resp.qp_state = 0;
        ib_copy_qp_attr_to_user(&resp, &qp_attr);
 
        if (copy_to_user((void __user *)(unsigned long)cmd.response,
diff --git a/drivers/infiniband/core/ucma.c
b/drivers/infiniband/core/ucma.c
index ca12acf..07fd247 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -842,6 +842,7 @@ static ssize_t ucma_init_qp_attr(struct ucma_file *file,
        if (ret)
                goto out;
 
+       resp.qp_state = 0;
        ib_copy_qp_attr_to_user(&resp, &qp_attr);
        if (copy_to_user((void __user *)(unsigned long)cmd.response,
                         &resp, sizeof(resp)))
diff --git a/drivers/infiniband/core/uverbs_marshall.c
b/drivers/infiniband/core/uverbs_marshall.c
index 5440da0..cceaf33 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -35,6 +35,7 @@
 void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst, struct ib_ah_attr *src)
 {
+       memset(&dst->grh, 0, sizeof(dst->grh));
        memcpy(dst->grh.dgid, src->grh.dgid.raw, sizeof src->grh.dgid);
        dst->grh.flow_label        = src->grh.flow_label;
        dst->grh.sgid_index        = src->grh.sgid_index;
@@ -46,6 +47,7 @@ void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
        dst->static_rate           = src->static_rate;
        dst->is_global             = src->ah_flags & IB_AH_GRH ? 1 : 0;
        dst->port_num              = src->port_num;
+       dst->reserved              = 0;
 }
 EXPORT_SYMBOL(ib_copy_ah_attr_to_user);
 
@@ -83,6 +85,7 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
        dst->rnr_retry          = src->rnr_retry;
        dst->alt_port_num       = src->alt_port_num;
        dst->alt_timeout        = src->alt_timeout;
+       memset(dst->reserved, 0, sizeof(dst->reserved));
 }
 EXPORT_SYMBOL(ib_copy_qp_attr_to_user);

-- 
Vasiliy
