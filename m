Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0KZP1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:27:51 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45933 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab0KZP1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:27:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=iXCifzTs40ptAc+WqBjELu3+19vaor639LmjUGBucM25xz+iIhLcYAohXS6hkPPl0K
         7rZ7gpHjDTEg3AuVClpWIA8ppz5sk0a0NlAHTMKoH5AwYmLqfYbAxdRXV+/Htj7VDz8u
         gN/1VMq/plwCbvbKp4aMtcijIl4lRTKSRMhu0=
Date: Fri, 26 Nov 2010 18:27:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        ming.m.lin@intel.com, peterz@infradead.org
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
Message-ID: <20101126152744.GA5620@lenovo>
References: <AANLkTikjfM=8xa8smgT6D_WTYC_S-JZ69iiqu8gD21sK@mail.gmail.com> <AANLkTin1Q0eo4mFbSCeO4RNrK8Men0Q3r_x9_dCse11Q@mail.gmail.com> <AANLkTimOY=58aW0OsWhTRjc5tgxNApKpReNh0hwK7SJJ@mail.gmail.com> <AANLkTikWB0TbCO1JLCtk03HAV0qEj63fPZ+rzViAZJS4@mail.gmail.com> <AANLkTik1R-4kvoE81oqTrSm6RZdO005kL_xfbqfyrnFm@mail.gmail.com> <AANLkTi=1nxsKR2e9MAEzbPNt66TUD9Ltd+ug+C7Jhk+Y@mail.gmail.com> <AANLkTin63X+2pOuRYHF0ntnB95g-MWjug-sUYAFGFnxa@mail.gmail.com> <AANLkTikG9swqOxF2GwhvKY__Lbgt1+GgRfra-+DrBsk0@mail.gmail.com> <AANLkTi=jLNwKOqUKay9c9aLVd_7do5n1iCYEUkOfS7G+@mail.gmail.com> <AANLkTintEs9oM+UDzjymAMGfiYCBxPeEtY-NHA55s-Ge@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTintEs9oM+UDzjymAMGfiYCBxPeEtY-NHA55s-Ge@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 02:54:39PM +0100, Stephane Eranian wrote:
...
> >
> > No, single thread mode means _any_ single thread is running,
> > Stephane I'll describe some more a bit later (as only reach home),
> > ok?
> 
> From the manual:
> 
> 00 — None. Count only when neither logical processor is active.
> 01 — Single. Count only when one logical processor is active (either 0 or 1).
> 10 — Both. Count only when both logical processors are active.
> 11 — Any. Count when either logical processor is active.
> 
> In per-thread mode, you won't hit 00. I suspect you want to
> disallow 01, 10 (or CAP_SYS_ADMIN). Otherwise, you want
> to force 11, i.e., can't figure out what's going on in the other
> HT thread.
> 

 No ;) The key moment here that this flags are related to _activity_ of
logical thread and I guess they were introduced just to allow measuring
if user-space application does win from using HT or not (since for
some loads the HT simply drops the perfomance).

 But I guess what you have in mind is actually set in ESCR register --
flags T0/1_USR, T0/1_OS. And these bits are controlled by kernel and 
"measurement" of events happening on another thread is simply not
allowed, though you still can set on which CPL level measure the event
by 'exclude_kernel','exclude_user' config attributes.

 Though there are still events which are "shared" across threads,
so such events will need CAP_SYS_ADMIN permission.

 Here is what I've put in comments while were touching this code.

	/*
	 * NOTE: P4_CCCR_THREAD_ANY has not the same meaning as
	 * in Architectural Performance Monitoring, it means not
	 * on _which_ logical cpu to count but rather _when_, ie it
	 * depends on logical cpu state -- count event if one cpu active,
	 * none, both or any, so we just allow user to pass any value
	 * desired.
	 *
	 * In turn we always set Tx_OS/Tx_USR bits bound to logical
	 * cpu without their propagation to another cpu
	 */

	/*
	 * if an event is shared accross the logical threads
	 * the user needs special permissions to be able to use it
	 */
	if (p4_event_bind_map[v].shared) {
		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
			return -EACCES;
	}

  Cyrill
