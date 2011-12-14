Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1LNO2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:28:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1LNO2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:28:00 -0500
Message-ID: <4EE8B269.2080803@redhat.com>
Date: Wed, 14 Dec 2011 16:27:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Nate Custer <nate@cpanel.net>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: kvm deadlock
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net> <20111214122511.GD18317@amt.cnet> <4EE8A7ED.7060703@redhat.com> <20111214140027.GF18317@amt.cnet> <4EE8AC88.1040205@redhat.com> <20111214140612.GG18317@amt.cnet>
In-Reply-To: <20111214140612.GG18317@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 04:06 PM, Marcelo Tosatti wrote:
> On Wed, Dec 14, 2011 at 04:02:48PM +0200, Avi Kivity wrote:
> > On 12/14/2011 04:00 PM, Marcelo Tosatti wrote:
> > > The other traces have apparently bogus NMI interrupts, but it might be a
> > > software bug, OK.
> > 
> > These are from sysrq-blah, no?  I'm looking at them now.
>
> I don't know. Its a hang ? It could be memory corruption (of the timer
> olist) instead of a bogus NMI actually, the second.

Looks like lots of cpus are waiting on the smp_call_function_single()
lock.  Looks like rcu is complaining:


[ 4959.814010]  [<ffffffff81252e47>] __const_udelay+0x2c/0x2e
[ 4959.814017]  [<ffffffff81027449>]
native_safe_apic_wait_icr_idle+0x31/0x3d
[ 4959.814024]  [<ffffffff81027f11>]
__default_send_IPI_dest_field.constprop.0+0x23/0x5d
[ 4959.814032]  [<ffffffff81027f93>]
default_send_IPI_mask_sequence_phys+0x48/0x97
[ 4959.814039]  [<ffffffff81089848>] ? tick_nohz_handler+0xdf/0xdf
[ 4959.814044]  [<ffffffff8102b561>] physflat_send_IPI_all+0x17/0x19
[ 4959.814052]  [<ffffffff81028102>]
arch_trigger_all_cpu_backtrace+0x57/0x89
[ 4959.814057]  [<ffffffff810c7711>] __rcu_pending+0x89/0x328
[ 4959.814063]  [<ffffffff81089848>] ? tick_nohz_handler+0xdf/0xdf
[ 4959.814067]  [<ffffffff810c7e0a>] rcu_check_callbacks+0x88/0xb9
[ 4959.814071]  [<ffffffff8106aeba>] update_process_times+0x3f/0x75

Maybe the core issue is that CPU 3 is spinning in do_insn_fetch() and
denying rcu grace periods.  Nate, can you provide a few more dumps (this
is looking at the second paste, so more of the same)?

-- 
error compiling committee.c: too many arguments to function

