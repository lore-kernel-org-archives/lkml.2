Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1I1L6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 07:58:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54544 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab1I1L6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 07:58:15 -0400
MIME-Version: 1.0
In-Reply-To: <1316051175-17780-5-git-send-email-glommer@parallels.com>
References: <1316051175-17780-1-git-send-email-glommer@parallels.com>
	<1316051175-17780-5-git-send-email-glommer@parallels.com>
Date: Wed, 28 Sep 2011 15:58:13 +0400
Message-ID: <CANaxB-wy8VDv0Wjni6UzcfBzSgNn=bZBey5f+fXHebNuek=O1A@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] per-cgroup tcp buffers control
From: Andrew Wagin <avagin@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* tcp_destroy_cgroup_fill() is executed for each cgroup and
initializes some proto methods. proto_list is global and we can
initialize each proto one time. Do we need this really?

* And when a cgroup is destroyed, it cleans proto methods
(tcp_destroy_cgroup_fill), how other cgroups will work after that?

* What about proto, which is registered when cgroup mounted?

My opinion that we may initialize proto by the following way:

+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM+       .enter_memory_pressure
= tcp_enter_memory_pressure_nocg,
+       .sockets_allocated      = sockets_allocated_tcp_nocg,
+       .memory_allocated       = memory_allocated_tcp_nocg,
+       .memory_pressure        = memory_pressure_tcp_nocg,
+#else
        .enter_memory_pressure  = tcp_enter_memory_pressure,
        .sockets_allocated      = sockets_allocated_tcp,
        .memory_allocated       = memory_allocated_tcp,
        .memory_pressure        = memory_pressure_tcp,
+#endif

It should work, because the root memory cgroup always exists.

>+int tcp_init_cgroup_fill(struct proto *prot, struct cgroup *cgrp,
>+                        struct cgroup_subsys *ss)
>+{
>+       prot->enter_memory_pressure     = tcp_enter_memory_pressure;
>+       prot->memory_allocated          = memory_allocated_tcp;
>+       prot->prot_mem                  = tcp_sysctl_mem;
>+       prot->sockets_allocated         = sockets_allocated_tcp;
>+       prot->memory_pressure           = memory_pressure_tcp;
>+
>+       return 0;
>+}


> +void tcp_destroy_cgroup_fill(struct proto *prot, struct cgroup *cgrp,
> +                            struct cgroup_subsys *ss)
> +{
> +       prot->enter_memory_pressure     = tcp_enter_memory_pressure_nocg;
> +       prot->memory_allocated          = memory_allocated_tcp_nocg;
> +       prot->prot_mem                  = tcp_sysctl_mem_nocg;
> +       prot->sockets_allocated         = sockets_allocated_tcp_nocg;
> +       prot->memory_pressure           = memory_pressure_tcp_nocg;
>

>@@ -2220,12 +2220,16 @@ struct proto tcpv6_prot = {
>       .hash                   = tcp_v6_hash,
>       .unhash                 = inet_unhash,
>       .get_port               = inet_csk_get_port
> +       .enter_memory_pressure  = tcp_enter_memory_pressure_nocg,
> +       .sockets_allocated      = sockets_allocated_tcp_nocg,
> +       .memory_allocated       = memory_allocated_tcp_nocg,
> +       .memory_pressure        = memory_pressure_tcp_nocg,
