Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0HWIzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:55:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51226 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab0HWIzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=tblYgxsow6vptTJp1bAks3/vdQHx8+Iz0AEQkoxD38WTt+K0Nl0YyvDnjQPw0AENVK
         Z52o/YPFZXTC0vfuSoT9YWx8YCaTTglB581TkZeXntoMuYuhqw7vTkjcKkAB+GdJSSrG
         AiUOyA5QUd+z3N3Yo/1qv4hYacEUmEQoKQKSI=
Date: Mon, 23 Aug 2010 10:55:26 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] posix clocks: introduce syscall for clock tuning.
Message-ID: <20100823085526.GB18510@riccoc20.at.omicron.at>
References: <cover.1282550649.git.richard.cochran@omicron.at>
 <e253843e07ce5d15c2c8d11ce786bf979ed85ca5.1282550649.git.richard.cochran@omicron.at>
 <AANLkTi=Fa38ufwR8PDc+HBHmLT53eWRA0ofrobm0n9-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Fa38ufwR8PDc+HBHmLT53eWRA0ofrobm0n9-w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 10:25:35AM +0200, Bert Wesarg wrote:
> On Mon, Aug 23, 2010 at 10:16, Richard Cochran <richardcochran@gmail.com> wrote:
> > diff --git a/kernel/compat.c b/kernel/compat.c
> > index 5adab05..df1e469 100644
> > --- a/kernel/compat.c
> > +++ b/kernel/compat.c
> > @@ -628,6 +628,26 @@ long compat_sys_clock_gettime(clockid_t which_clock,
> >        return err;
> >  }
> >
> > +long compat_sys_clock_adjtime(clockid_t which_clock, int ppb,
> > +               struct compat_timespec __user *tp)
> > +{
> > +       long err;
> > +       mm_segment_t oldfs;
> > +       struct timespec ts, *ptr = NULL;
> 
> Shouldn't ptr be initialized with tp?

It could be, but the logic turns out the same either way. The
semantics of the call is, if 'tp' is NULL, then adjust the frequency
by 'ppb', otherwise adjust clock time by 'tp'.

> 
> > +
> > +       if (tp) {
> > +               if (get_compat_timespec(&ts, tp))
> > +                       return -EFAULT;
> > +               ptr = &ts;
> > +       }
> > +       oldfs = get_fs();
> > +       set_fs(KERNEL_DS);
> > +       err = sys_clock_adjtime(which_clock, ppb,
> > +                               (struct timespec __user *) ptr);
> > +       set_fs(oldfs);
> > +       return err;
> > +}
> > +
> >  long compat_sys_clock_getres(clockid_t which_clock,
> >                struct compat_timespec __user *tp)
> >  {
