Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1BQCAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:00:51 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34269 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1BQCAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:00:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FEJduEZMDqjgsX4h15UDSbrX+MVcqKz1aTYqfuVZ6rvjmS1YOkin64g9ik40Q/T11m
         izX2xCtrBbcE8VPCNCsnpehWMWb0r409URunBDn0P67s3n1QBTz7lr6fQqGgy+TbYnYq
         zCtrrmSqVYQKKyi19E7iHTZuHGsfFTpGUFxMI=
MIME-Version: 1.0
In-Reply-To: <4D5B1616.8030807@ziu.info>
References: <4D5B1616.8030807@ziu.info>
Date: Thu, 17 Feb 2011 10:00:47 +0800
Message-ID: <AANLkTimOXYcGdMG501Nsseh0hKvo+VrcpvkC8aw2oNNk@mail.gmail.com>
Subject: Re: question: cpu.shares and parent-children relationshp in the hierarchy
From: Yong Zhang <yong.zhang0@gmail.com>
To: Michal Soltys <soltys@ziu.info>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 8:11 AM, Michal Soltys <soltys@ziu.info> wrote:
> Hi,
>
> I've been testing how this works in practice, and I have few
> configurations I'm not sure why they behave the way they do.
>
> All the test processes just drain cpu with an infinite loop.
> All of them are pinned to single cpu core. cgroup with just
> -o cpu is mounted, and the scenario is following (in brackets
> - assigned cpu.shares):
>
>    root(1024)
>   /          \
> Y(1024)      X(4096)
>            /       \        \
>         A(8192)   B(8192)  task-x(1024)

I assume loadme(x) is an process of group X, like above.

If so, there isn't any problem with it.

Thanks,
Yong

>
> Four test processes sit in X, Y, A and B; root is "empty"
> (effectively idle processes). The one in Y expectedly gets
> 20% cpu, A and B divide the cpu share equally, but - why do
> the process in X gets only ~4.75% ? Essentially:
>
> 11:36:45 PM       PID    %usr %system  %guest    %CPU   CPU  Command
> 11:36:50 PM     29472   20.00    0.00    0.00   20.00     1  loadme(y)
> 11:36:50 PM     29473    4.80    0.00    0.00    4.80     1  loadme(x)
> 11:36:50 PM     29474   37.60    0.00    0.00   37.60     1  loadme(a)
> 11:36:50 PM     29475   37.60    0.00    0.00   37.60     1  loadme(b)
>
> In the other words - what is the intended relation between ancestor's
> cpu.shares and its children ? Looking at the example above, it looks
> like the task in X should get 4/5 (root unused, 1/5 for Y, the rest
> for X subtree) * 1/5 (from assigned values in X subtree,
> 4096/20480) - but that would be ~16%.
>
> The task in X behaves like if X had 1024 - maybe it's always assumed
> when parent-children relationship is considered, and the actual value
> is used only when dividing cpu between siblings ?
>
> If I move the test task from X to root, the situation will change to:
>
> 11:56:49 PM       PID    %usr %system  %guest    %CPU   CPU  Command
> 11:56:54 PM     29472   16.60    0.00    0.00   16.60     1  loadme(y)
> 11:56:54 PM     29473   16.60    0.00    0.00   16.60     1  loadme(root)
> 11:56:54 PM     29474   33.20    0.20    0.00   33.40     1  loadme(a)
> 11:56:54 PM     29475   33.40    0.00    0.00   33.40     1  loadme(b)
>
> In this scenario, everything seems as expected - 1/6 for Y, 1/6 for root,
> 4/6 for X subtree.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
