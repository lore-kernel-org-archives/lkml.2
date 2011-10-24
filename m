Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1JXReB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:34:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab1JXReA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:34:00 -0400
Date: Mon, 24 Oct 2011 13:33:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        holzheu@linux.vnet.ibm.com, akpm@linux-foundation.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: kdump: crash_kexec()-smp_send_stop() race in panic
Message-ID: <20111024173336.GB8044@redhat.com>
References: <1319468137.3615.16.camel@br98xy6r>
 <m1ipneifqv.fsf@fess.ebiederm.org>
 <CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
 <m1aa8qfhdk.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1aa8qfhdk.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 10:07:19AM -0700, Eric W. Biederman wrote:
> Américo Wang <xiyou.wangcong@gmail.com> writes:
> 
> > On Mon, Oct 24, 2011 at 11:14 PM, Eric W. Biederman
> > <ebiederm@xmission.com> wrote:
> >> Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:
> >>
> >>> Hello Vivek,
> >>>
> >>> In our tests we ran into the following scenario:
> >>>
> >>> Two CPUs have called panic at the same time. The first CPU called
> >>> crash_kexec() and the second CPU called smp_send_stop() in panic()
> >>> before crash_kexec() finished on the first CPU. So the second CPU
> >>> stopped the first CPU and therefore kdump failed.
> >>>
> >>> 1st CPU:
> >>> panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump
> >>>
> >>> 2nd CPU:
> >>> panic()->crash_kexec()->kexec_mutex already held by 1st CPU
> >>>        ->smp_send_stop()-> stop CPU 1 (stop kdump)
> >>>
> >>> How should we fix this problem? One possibility could be to do
> >>> smp_send_stop() before we call crash_kexec().
> >>>
> >>> What do you think?
> >>
> >> smp_send_stop is insufficiently reliable to be used before crash_kexec.
> >>
> >> My first reaction would be to test oops_in_progress and wait until
> >> oops_in_progress == 1 before calling smp_send_stop.
> >>
> >
> > +1
> >
> > One of my colleague mentioned the same problem with me inside
> > RH, given the fact that the race condition window is small, it would
> > not be easy to reproduce this scenario.
> 
> As for reproducing it I have a hunch you could hack up something
> horrible with smp_call_function and kprobes.
> 
> 
> On a little more reflection we can't wait until oops_in_progress goes
> to 1 before calling smp_send_stop.  Because if crash_kexec is not
> involved nothing we will never call smp_send_stop. 
> 
> So my second thought is to introduce another atomic variable
> panic_in_progress, visible only in panic.  The cpu that sets
> increments panic_in_progress can call smp_send_stop.  The rest of
> the cpus can just go into a busy wait.  That should stop nasty
> fights about who is going to come out of smp_send_stop first.

Introducing panic_on_oops atomic sounds good.

Thanks
Vivek
