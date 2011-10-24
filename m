Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1JXRGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:06:48 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42792 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035Ab1JXRGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:06:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: holzheu@linux.vnet.ibm.com, Vivek Goyal <vgoyal@redhat.com>,
        akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1319468137.3615.16.camel@br98xy6r>
	<m1ipneifqv.fsf@fess.ebiederm.org>
	<CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
Date: Mon, 24 Oct 2011 10:07:19 -0700
In-Reply-To: <CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
	(=?utf-8?Q?=22Am=C3=A9rico?= Wang"'s message of "Mon, 24 Oct 2011 23:23:33
 +0800")
Message-ID: <m1aa8qfhdk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX196tWS8QqTDVRqgSOUrIHnvRVYF9lMKsPA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Am=c3=a9rico Wang <xiyou.wangcong@gmail.com>?=
X-Spam-Relay-Country: **
Subject: Re: kdump: crash_kexec()-smp_send_stop() race in panic
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Mon, Oct 24, 2011 at 11:14 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:
>>
>>> Hello Vivek,
>>>
>>> In our tests we ran into the following scenario:
>>>
>>> Two CPUs have called panic at the same time. The first CPU called
>>> crash_kexec() and the second CPU called smp_send_stop() in panic()
>>> before crash_kexec() finished on the first CPU. So the second CPU
>>> stopped the first CPU and therefore kdump failed.
>>>
>>> 1st CPU:
>>> panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump
>>>
>>> 2nd CPU:
>>> panic()->crash_kexec()->kexec_mutex already held by 1st CPU
>>>        ->smp_send_stop()-> stop CPU 1 (stop kdump)
>>>
>>> How should we fix this problem? One possibility could be to do
>>> smp_send_stop() before we call crash_kexec().
>>>
>>> What do you think?
>>
>> smp_send_stop is insufficiently reliable to be used before crash_kexec.
>>
>> My first reaction would be to test oops_in_progress and wait until
>> oops_in_progress == 1 before calling smp_send_stop.
>>
>
> +1
>
> One of my colleague mentioned the same problem with me inside
> RH, given the fact that the race condition window is small, it would
> not be easy to reproduce this scenario.

As for reproducing it I have a hunch you could hack up something
horrible with smp_call_function and kprobes.


On a little more reflection we can't wait until oops_in_progress goes
to 1 before calling smp_send_stop.  Because if crash_kexec is not
involved nothing we will never call smp_send_stop. 

So my second thought is to introduce another atomic variable
panic_in_progress, visible only in panic.  The cpu that sets
increments panic_in_progress can call smp_send_stop.  The rest of
the cpus can just go into a busy wait.  That should stop nasty
fights about who is going to come out of smp_send_stop first.

Eric
