Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2A0SH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:07:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33348 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2A0SH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:07:56 -0500
Message-ID: <4F22E7F8.30804@lwfinger.net>
Date: Fri, 27 Jan 2012 12:07:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel BUG due to kernel page fault
References: <4F21D57F.7090103@lwfinger.net> <20120127164219.GE19323@redhat.com>
In-Reply-To: <20120127164219.GE19323@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 10:42 AM, Stanislaw Gruszka wrote:
> On Thu, Jan 26, 2012 at 04:36:47PM -0600, Larry Finger wrote:
>> Modules linked in: fuse autofs4 snd_pcm_oss snd_mixer_oss snd_seq
>> snd_seq_device edd nfs nfsd lockd auth_rpcgss nfs_acl sunrpc
>> exportfs ipv6 vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O)
>                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> RIP: 0010:[<ffffffff811e3ecb>]  [<ffffffff811e3ecb>] strnlen+0xb/0x30
> [snip]
>> Call Trace:
>>   [<ffffffff811e58ae>] string.isra.4+0x3e/0xd0
>>   [<ffffffff811e6889>] vsnprintf+0x219/0x600
>>   [<ffffffff81153093>] seq_printf+0x53/0x80
>>   [<ffffffff811e21db>] ? radix_tree_lookup+0xb/0x10
>>   [<ffffffff810ba5ab>] show_interrupts+0x24b/0x300
>>   [<ffffffff81153474>] seq_read+0x2b4/0x3f0
>>   [<ffffffff811531c0>] ? seq_lseek+0x100/0x100
>>   [<ffffffff8118b651>] proc_reg_read+0x81/0xc0
>>   [<ffffffff8112f967>] vfs_read+0xa7/0x160
>>   [<ffffffff8112fa65>] sys_read+0x45/0x90
>>   [<ffffffff813a33a2>] system_call_fastpath+0x16/0x1b
>
> This is call trace from cat /proc/interrupts, seems something pass
> malformed string to request_irq(). I do not think this is rtlwifi,
> rather that vbox thing.

Thanks for responding. Vbox may be guilty of a lot of things, but this is not 
one of them.

Just before I received your reply, I found the problem. The PCI driver in 
rtlwifi sets a flag to indicate that interrupts have been enabled, and uses that 
flag to tell if the cleanup needs to disable them. When I moved the code that 
starts mac80211, I also moved the statement that sets the flag. As a result, the 
driver was exiting with interrupts still enabled, and the BUG resulted from 
that. I can now unload the driver when firmware is not available.

Larry




