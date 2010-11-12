Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab0KLS3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:29:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:33273 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250Ab0KLS3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:29:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,188,1288594800"; 
   d="scan'208";a="626194917"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Vasiliy Kulikov <segooon@gmail.com>, Roland Dreier <rdreier@cisco.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Roland Dreier <rolandd@cisco.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Alex Chiang <achiang@hp.com>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Nov 2010 10:28:55 -0800
Subject: RE: [PATCH] infiniband: core: fix information leak to userland
Thread-Topic: [PATCH] infiniband: core: fix information leak to userland
Thread-Index: AcuClLekuIZFizuPTFOBwI1VpZ/URQAAO0AA
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B85224A6@orsmsx501.amr.corp.intel.com>
References: <1289054481-18145-1-git-send-email-segooon@gmail.com>
 <ada39r8ohiz.fsf@cisco.com> <20101112180844.GA11533@albatros>
In-Reply-To: <20101112180844.GA11533@albatros>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/infiniband/core/ucm.c
> b/drivers/infiniband/core/ucm.c
> index 08f948d..f7256f3 100644
> --- a/drivers/infiniband/core/ucm.c
> +++ b/drivers/infiniband/core/ucm.c
> @@ -629,6 +629,7 @@ static ssize_t ib_ucm_init_qp_attr(struct ib_ucm_file
> *file,
>         if (result)
>                 goto out;
> 
> +       resp.qp_state = 0;
>         ib_copy_qp_attr_to_user(&resp, &qp_attr);

I believe we want ib_copy_qp_attr_to_user() to assign	resp->qp_state = qp_attr->qp_state

> diff --git a/drivers/infiniband/core/ucma.c
> b/drivers/infiniband/core/ucma.c
> index ca12acf..07fd247 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -842,6 +842,7 @@ static ssize_t ucma_init_qp_attr(struct ucma_file
> *file,
>         if (ret)
>                 goto out;
> 
> +       resp.qp_state = 0;
>         ib_copy_qp_attr_to_user(&resp, &qp_attr);
>         if (copy_to_user((void __user *)(unsigned long)cmd.response,
>                          &resp, sizeof(resp)))
> diff --git a/drivers/infiniband/core/uverbs_marshall.c
> b/drivers/infiniband/core/uverbs_marshall.c
> index 5440da0..cceaf33 100644
> --- a/drivers/infiniband/core/uverbs_marshall.c
> +++ b/drivers/infiniband/core/uverbs_marshall.c
> @@ -35,6 +35,7 @@
>  void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst, struct
> ib_ah_attr *src)
>  {
> +       memset(&dst->grh, 0, sizeof(dst->grh));

We only need to set dst->grh.reserved = 0.  The other fields are assigned. 

- Sean
