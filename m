Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2DRPke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:40:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33780 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2DRPk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:40:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        majianpeng <majianpeng@gmail.com>
References: <20120418101231.GE1505@arm.com> <m1wr5d18fy.fsf@fess.ebiederm.org>
	<20120418141851.GG1505@arm.com> <m1ipgxrt11.fsf@fess.ebiederm.org>
	<20120418151545.GI1505@arm.com>
Date: Wed, 18 Apr 2012 08:44:27 -0700
In-Reply-To: <20120418151545.GI1505@arm.com> (Catalin Marinas's message of
	"Wed, 18 Apr 2012 16:15:45 +0100")
Message-ID: <m1ehrloxic.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19vyypZQo4KQo2FbYsj2VUi4+/CMiKrs7Q=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0016]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Catalin Marinas <catalin.marinas@arm.com>
X-Spam-Relay-Country: **
Subject: Re: Possible memory leaks in proc_sysctl.c
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Apr 18, 2012 at 03:52:58PM +0100, Eric W. Biederman wrote:
>> Catalin Marinas <catalin.marinas@arm.com> writes:
>> > On Wed, Apr 18, 2012 at 02:22:09PM +0100, Eric W. Biederman wrote:
>> >> Catalin Marinas <catalin.marinas@arm.com> writes:
>> >> > Following your commit f728019bb (sysctl: register only tables of sysctl
>> >> > files), I get several kmemleak reports. They all seem to be header
>> >> > allocations with kzalloc() in __register_sysctl_table() and
>> >> > __register_sysctl_paths(). The patch isn't simple to quickly figure out
>> >> > what may be wrong.
>> >> 
>> >> Due to a change in the data structure places where we register the
>> >> sysctl permanently and ignore the result from the register_sysctl_...
>> >> family of functions now report this leak.
>> >
>> > But is the header (or subheader, basically any pointer inside the
>> > kmalloc'ed object) never referenced from anywhere? I'm just trying to
>> > understand why kmemleak reports it as it seems that the header object is
>> > inserted in a ctl_dir.
>> 
>> It is never reference from anywhere because we never free the structure.
>> The job of the header is to be the structure that tells us how to free
>> things.
>> 
>> I see a couple of things going on.
>> - For compatibility the header that is returned is a dummy that just
>>   points to the real headers.
>> 
>> - Even without the compatibility we can get the same symptom if
>>   we register an empty directory.
>> 
>> So simply saying kmemleak shut up this is deliberate in these few cases
>> where we don't intend to unregister the structure and have a deliberate
>> leak seems the clean and maintainable way to go.
>
> OK, I got it now, sounds fair. But please add a comment to the
> kmemleak_not_leak() annotations so that others know it's a deliberate
> leak (rather than a false positive).
>
> Also the patch should include the linux/kmemleak.h file for the
> kmemleak_not_leak() prototype as header changes in the future may cause
> problems (I think the one you posted did not include it).

I will take a look when I merge the patch.

Would something like kmemleak_ignore() be better?  What I want is
kmemleak_this_is_a_deliberate_leak_so_shut_up(), but the API doesn't
seem to exactly include that function.  I'm not certain what the proper
name is as I haven't worked much with kmemleak.

Eric

