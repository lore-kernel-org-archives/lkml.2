Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2DSJ14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:27:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34905 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752970Ab2DSJ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:27:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+CBhR1g2KCRpHZO4xInpVCn2bJZo92GIPo5lYuas
	Ns4gyEuUDY8YH6
Message-ID: <1334827666.24764.245.camel@marge.simpson.net>
Subject: Re: 20120419 disk scheduler
From: Mike Galbraith <efault@gmx.de>
To: sunzixun <faye.zixun@gmail.com>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>
Date: Thu, 19 Apr 2012 11:27:46 +0200
In-Reply-To: <CA+dmLLeNG6Sb_k9sdE9QTMjbBJxd_r7ay5uNxLVV_E5u-=abrw@mail.gmail.com>
References: <CA+dmLLeNG6Sb_k9sdE9QTMjbBJxd_r7ay5uNxLVV_E5u-=abrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

我不知道多少 LKML 读者可以阅读这篇文章。

On Thu, 2012-04-19 at 17:15 +0800, sunzixun wrote: 
> -许加强(110781198) 3:33:12 PM
> 问一个问题： 对于一个block 我们做IO，虽然会经过disk scheduler那一层，我想问的就是 是不是 所有情况下IO
> scheduler都可以保证这个block里面 sector地址在前面的 sectors 一定比在后面的先被flush到磁盘上。
> eric(3251550) 3:33:31 PM
> 不能啊。
> 孙子荀 (448981776) 3:36:36 PM
> 我觉得能的吧？
> -eric(3251550) 3:38:35 PM
> 不能，很复杂。
> eric(3251550) 3:38:52 PM
> io受多重控制。
> -eric(3251550) 3:39:11 PM
> 要想保序。要用barrier io这种方式。
> 孙子荀 (448981776) 3:39:13 PM
> 就看 block size 如果和sector一样大
> 孙子荀 (448981776) 3:40:04 PM
> 我感觉还是应该可以啊
> -eric(3251550) 3:40:13 PM
> 除非这个一个io，而且不能被拆分。
> eric(3251550) 3:40:36 PM
> block和sector一样大。还谈何前面的sector和后面的sector
> 孙子荀 (448981776) 3:41:22 PM
> 对 你然后反过来想
> 孙子荀 (448981776) 3:41:39 PM
> 一样大 是可以保证的 。。那不一样大 怎么不保证呢
> eric(3251550) 3:43:09 PM
> 不一样大。。就麻烦了。。
>   -eric(3251550) 3:43:17 PM
> 要被拆分。
>   -eric(3251550) 3:43:43 PM
> 写io都要被拆成4k，4k处理。
>   -eric(3251550) 3:44:02 PM
> 保证顺序，内核专门用了一种结构来处理。
>   -eric(3251550) 3:44:06 PM
> barrier io.
>   -孙子荀 (448981776) 3:44:20 PM
> 看来我还要想想
>   -eric(3251550) 3:44:55 PM
> 看文档。
>   -孙子荀 (448981776) 3:49:05 PM
> 加强是问 内核保证按sector ，还是包括最终的硬盘落地？
>   -孙子荀 (448981776) 3:49:29 PM
> 如果经过raid cache ，磁盘交叉因子  那确实复杂一些
>   -孙子荀 (448981776) 3:50:18 PM
> 
>   -BJ-许加强(110781198) 3:52:12 PM
> 恩  应该是不能保证的，得看磁头的当前位置决定
>   -BJ-许加强(110781198) 3:53:08 PM
> 但如果不是简单的磁盘，而是SAN的那种， IO要走fiber channel或者infiniband到远处的磁盘，是不是也不能保证
>   -eric(3251550) 3:53:20 PM
> 都不能。
>   -孙子荀 (448981776) 3:55:22 PM
> 你问 io sched 我觉得这层是可以的
>   -孙子荀 (448981776) 3:55:30 PM
> 但是硬件 那肯定不能
>   -eric(3251550) 3:56:05 PM
> io sched也不能。。
>   -BJ-许加强(110781198) 3:56:06 PM
> 我觉得这层 在排队的时候  应该也有可能让后面sector的插队到前面来吧？
>   -eric(3251550) 3:56:38 PM
> 排队是按序的。但是随时可能被重新定位。
>   -eric(3251550) 3:56:58 PM
> 调度要考虑饿死的情况。
>   -BJ-许加强(110781198) 3:57:06 PM
> 被重新定位的时候  是考虑哪些因素？
>   -孙子荀 (448981776) 3:57:11 PM
> io sched 为什么不能？
>   -孙子荀 (448981776) 3:57:39 PM
> 重新定位 io sched 是不知道磁头信息的
>   -eric(3251550) 3:57:39 PM
> 饿死。。长时等待。。请求合并。等等。
>   -孙子荀 (448981776) 3:57:49 PM
> 对啊 ，等待 和合并 也是顺序的
>   -eric(3251550) 3:57:51 PM
> 软件不管 磁头信息。
>   -eric(3251550) 3:57:56 PM
> 那是ncq的实现。
>   -孙子荀 (448981776) 3:57:58 PM
> 不会跳回
>   -孙子荀 (448981776) 3:58:27 PM
> 比如 一个block 分成scetor 1 2 3 4
> 请问什么调度会 走成 4 2 1 3
>   -eric(3251550) 3:59:04 PM
> 只是调度这一层吗？
>   -孙子荀 (448981776) 3:59:12 PM
> 是啊
>   -eric(3251550) 3:59:58 PM
> 调度这层不会。
>   -BJ-许加强(110781198) 4:01:08 PM
> 假设调度层不会，那么调度层下面   哪些情况会导致乱序？
>   -eric(3251550) 4:03:28 PM
> 很多情况。
>   -孙子荀 (448981776) 4:03:45 PM
> 调度可以看源码 。我晚上仔细看看。。
> 
> 硬件就太多了，像刚才EMC哥们告诉我的交叉因子
>   -eric(3251550) 4:03:48 PM
> 上层应用还可能并发。
>   -eric(3251550) 4:04:17 PM
> I/O barrier requests are used to guarantee ordering around the barrier requests.
>   -eric(3251550) 4:04:39 PM
> All requests queued before a barrier request must be finished (made it
> to the physical medium) before the barrier request is started, and all
> requests queued after the barrier request must be started only after
> the barrier request is finished (again, made it to the physical
> medium).
>   -eric(3251550) 4:05:04 PM
> 保序。。。前面的必须完成。后面的必须等保序io完成之后再完成。
>   -eric(3251550) 4:05:13 PM
> 被插入 打断也不行。
>   -eric(3251550) 4:05:51 PM
> 只保证 1，2，3，4，5也不行。还必须不能中间被插入新的io
> NР骒rybX肚v^)藓{.n+伐{赙zXФ≤}财z&j:+v赙zZ++zf＂h~izwア?ㄨ&)撷f^j谦ym@Aa囤0鹅hi


