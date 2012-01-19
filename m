Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2ASJVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:21:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:56060 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab2ASJVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:21:43 -0500
Message-ID: <4F17E0A4.9040004@linutronix.de>
Date: Thu, 19 Jan 2012 10:21:40 +0100
From: Richard Weinberger <rw@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: Netfilter: New target: RLOG
References: <1326926610-17830-1-git-send-email-rw@linutronix.de> <20120119091248.GA32391@1984>
In-Reply-To: <20120119091248.GA32391@1984>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.01.2012 10:12, Pablo Neira Ayuso wrote:
> Hi Richard,
>
> On Wed, Jan 18, 2012 at 11:43:25PM +0100, Richard Weinberger wrote:
>> RLOG is a new log target, it works like LOG with the exception that it writes to ring buffers.
>> It makes use of Steven Rostedt's ring_buffer subsystem.
>> I've used Steve's ring buffer because it allows concurrent writes. IOW it's very fast.
>> For more details see: Documentation/trace/ring-buffer-design.txt.
>>
>> Each ring buffer is represented as a pipe-like file in /proc/net/netfilter/xt_RLOG/.
>> You can read from it with and program you like (cat, syslog, etc...).
>> The default size is 1MiB. With this size it can store approximately 5000 messages.
>>
>> - Why not LOG?
>> I like the LOG target a lot but I really hat it when it floods my kernel syslog.
>> dmesg becomes useless.
>> Writing all log messages to a file using syslogd also not always the best solution.
>> Most of the time my firewall logs just waste disk space.
>>
>> Compared with Steve's ring_buffer, the kernel syslog is rather slow.
>> Especially when the firewall logs very much syslog becomes a bottleneck.
>> As we all know printk() is not fast.
>>
>> - Why not ULOG/NFLOG?
>> Because it cannot replace LOG.
>> Details like PHYSIN and PHYSOUT are not available form the packet headers.
>> Also on many Linux systems ulogd is not available/supported.
>
> We only include physin and phyout if netfilter bridge is enabled. I
> may be missing anything but, why can these be useful if bridging is not
> enabled?

Of course they are only useful if bridging enabled.
In nearly all of my use-cases I'm using bridging (KVM, LXC, ...).

>> - Why RLOG?
>> Using RLOG you can have many ring buffers with all kind of logs.
>> If your firewall goes nuts you don't have to mess you rule-set with adding
>> new LOG rules to find out what's going on.
>> Just install a few RLOG rules with small buffer sized and read them if you don't
>> know what's going on.
>> If you make you firewall rule-set per default verbose using LOG or NFLOG it will
>> generate lot's of useless messages which you'll never ever read.
>> With RLOG you can bypass this problem.
>> On my firewall I record only useful data to the disk. Everything else goes into RLOG.
>> If your firewall is really busy and you want to log nearly everything, c
>> reate a big ring buffer and read from is using your favorite userspace tool.
>> In case the buffer fills faster than the userspace consumes it, RLOG will warn you.
>> I'd also possible to resize the buffer.
>
> I still think this can be useful.
>
> But, why don't you add this to the LOG target as an extension instead
> of yet another target?

Yeah, I could add --ring, --ring-size and --add-timestamp to LOG.
What about a rlog_common.o which can be used by ipt_LOG and ip6t_LOG?

Thanks,
//richard
