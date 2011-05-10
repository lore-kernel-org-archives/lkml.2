Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1EJGe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 02:34:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab1EJGe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 02:34:56 -0400
Date: Tue, 10 May 2011 08:34:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: UV BAU fix for non-consecutive nasids
Message-ID: <20110510063445.GB11595@elte.hu>
References: <E1QJWvo-0006ug-Fd@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QJWvo-0006ug-Fd@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> @@ -1365,12 +1373,14 @@ uv_activation_descriptor_init(int node,
>  		memset(bd2, 0, sizeof(struct bau_desc));
>  		bd2->header.sw_ack_flag = 1;
>  		/*
> -		 * base_dest_nodeid is the nasid of the first uvhub
> -		 * in the partition. The bit map will indicate uvhub numbers,
> -		 * which are 0-N in a partition. Pnodes are unique system-wide.
> +		 * The base_dest_nasid set in the message header is the nasid
> +		 * of the first uvhub in the partition. The bit map will
> +		 * indicate destination pnode numbers relative to that base.
> +		 * They may not be consecutive if nasid striding is being used.
>  		 */
> -		bd2->header.base_dest_nodeid = UV_PNODE_TO_NASID(uv_partition_base_pnode);
> -		bd2->header.dest_subnodeid = 0x10; /* the LB */
> +		bd2->header.base_dest_nasid =
> +					UV_PNODE_TO_NASID(part_base_pnode);
> +		bd2->header.dest_subnodeid = UV_LB_SUBNODEID;
>  		bd2->header.command = UV_NET_ENDPOINT_INTD;
>  		bd2->header.int_both = 1;

This code is sick. Illness: too long lines.

checkpatch warned you but you applied the wrong cure and
broke the lines in an ugly way.

Can you	think of another cure? One of the many options:

  - eliminate many repetitive strings
  - reduce indentation by the introduction of helper inlines
  - sensible shortening of variable/field/definition names

... applies to this particular case and will solve the problem.

> @@ -1528,6 +1539,15 @@ static int __init uv_init_per_cpu(int nu
>  		bcp = &per_cpu(bau_control, cpu);
>  		memset(bcp, 0, sizeof(struct bau_control));
>  		pnode = uv_cpu_hub_info(cpu)->pnode;
> +		if ((pnode - base_part_pnode) >= UV_DISTRIBUTION_SIZE) {
> +			printk(KERN_EMERG
> +				"cpu %d pnode %d-%d beyond %d; BAU disabled\n",
> +				cpu, pnode, base_part_pnode,
> +				UV_DISTRIBUTION_SIZE);

See my points above.

> @@ -1585,6 +1605,20 @@ static int __init uv_init_per_cpu(int nu
>  nextsocket:
>  			socket++;
>  			socket_mask = (socket_mask >> 1);
> +			/* each socket gets a local array of pnodes/hubs */
> +			bcp = smaster;
> +			bcp->target_hub_and_pnode = kmalloc_node(
> +				sizeof(struct hub_and_pnode) *
> +				num_possible_cpus(), GFP_KERNEL, bcp->osnode);
> +			memset(bcp->target_hub_and_pnode, 0,
> +				sizeof(struct hub_and_pnode) *
> +				num_possible_cpus());
> +			for_each_present_cpu(tcpu) {
> +				bcp->target_hub_and_pnode[tcpu].pnode =
> +					uv_cpu_hub_info(tcpu)->pnode;
> +				bcp->target_hub_and_pnode[tcpu].uvhub =
> +					uv_cpu_hub_info(tcpu)->numa_blade_id;
> +			}

See my points above.

Thanks,

	Ingo
