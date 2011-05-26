Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab1EZSnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:43:33 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:36172 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754200Ab1EZSnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:43:32 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: vIDRCuUVM1mJSQKKbCBvOAm3t_9AuF0zq.UKFbgIGHEZEMy
 iJpMi7FtHgpyjoXTfSetVK0DdqOwJcZKEW_SA5SrLBwSdlsoVzXrk8SqaA0I
 vV1UpLznPp9J1MPWW5qroW3qhx4ay5dse.2zmF9icEqQZJxNFhuStQ25p20I
 XyLM7mPpoRlR4cAXjVn5aqYlWeRbPCeSOzWkfGxUDpCg2xJqmCVFswW7sXFH
 igzj5.zruK9eOd9F91K3QwZZVV7E5uWsnWQK57SZ1Ta1Xu0S5hPB_8KrorMG
 plm0U7lFwUHWnlGVUSAANSXk5255jrfUnMXYOqyTRaYso_H_KmjwwmsWf7Ot
 34bLY56wJAcbDdtYtP8PPamE8hIrJVPGuL5HS1o7RnbB..8TVNjnbIh.oxPs
 U8P_TolQDSbCPDHQgMYp36IbVWbzSDJ6N_qQraGa8
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DDE9F4E.9090303@schaufler-ca.com>
Date: Thu, 26 May 2011 11:43:26 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Drewry <wad@chromium.org>, Colin Walters <walters@verbum.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>	 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>	 <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>	 <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu>	 <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu>	 <alpine.LFD.2.02.1105251836030.3078@ionos>	 <20110525180100.GY19633@outflux.net>	 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>	 <20110525191152.GC19633@outflux.net>	 <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>	 <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>	 <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com>	 <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>	 <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com> <1306429636.3857.3.camel@gandalf.stny.rr.com>
In-Reply-To: <1306429636.3857.3.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2011 10:07 AM, Steven Rostedt wrote:
> On Thu, 2011-05-26 at 09:46 -0700, Linus Torvalds wrote:
>
>> And if you filter system calls, it's entirely possible that you can
>> attack suid executables through such a vector. Your "limit system
>> calls for security" security suddenly turned into "avoid the system
>> call that made things secure"!
>>
>> See what I'm saying?
> So you are not complaining about this implementation, but the use of
> syscall filtering?
>
> There may be some user that says, "oh I don't want my other apps to be
> able to call setuid" thinking it will secure their application even
> more. But because that application did the brain dead thing to not check
> the return code of setuid, and it just happened to be running
> privileged, it then execs off another application that can root the box.
>
> Because, originally that setuid would have succeeded if the user did
> nothing special, but now with this filtering, and the user thinking that
> they could limit their app from doing harm, they just opened up a hole
> that caused their app to do the exact opposite and give the exec'd app
> full root privileges.
>
> Did I get this right?

Yes. Some system calls are there so that you can turn off
privilege. There was a major exploit with sendmail when capabilities
were first introduced that brought the potential for this sort of
problem into the public eye. Kernel mechanisms intended to provide
additional security have to be massively careful about the impact
they may have on applications that are currently security aware and
that make use of the existing mechanisms. The ACL mechanism is much
more complicated than it probably ought to be to accommodate chmod()
and capabilities go way over the top to deal with traditional root
behavior.

> -- Steve
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

