Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031460Ab2CFWjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:39:31 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39709 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031250Ab2CFWja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:39:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jkacur@gmail.com designates 10.229.102.79 as permitted sender) smtp.mail=jkacur@gmail.com; dkim=pass header.i=jkacur@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120306161945.770871645@goodmis.org>
References: <20120306161636.491172179@goodmis.org>
	<20120306161945.770871645@goodmis.org>
Date: Tue, 6 Mar 2012 23:39:28 +0100
X-Google-Sender-Auth: fM5rRH5rKXpU98NJ7na_z8Igk7M
Message-ID: <CAONaPpFnn1EDh-NbJ5=iKw9q4N41KGVfKqJeO0NXvyTLjpzr4w@mail.gmail.com>
Subject: Re: [PATCH RT 04/25][RFC 3.0.23-rt39-rc1] revert-seqlock-remove-unused-functions
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 5:16 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
>
> revert: seqlock-remove-unused-functions.patch
>
> Revert:
>
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Sat Jul 16 18:38:22 2011 +0200
>
>    seqlock-remove-unused-functions.patch
>
>    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seqlock.h |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
> index b990f6e..c6db9fb 100644
> --- a/include/linux/seqlock.h
> +++ b/include/linux/seqlock.h
> @@ -69,6 +69,17 @@ static inline void write_sequnlock(seqlock_t *sl)
>        spin_unlock(&sl->lock);
>  }
>
> +static inline int write_tryseqlock(seqlock_t *sl)
> +{
> +       int ret = spin_trylock(&sl->lock);
> +
> +       if (ret) {
> +               ++sl->sequence;
> +               smp_wmb();
> +       }
> +       return ret;
> +}
> +
>  /* Start of read calculation -- fetch last complete writer token */
>  static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
>  {
> @@ -237,4 +248,14 @@ static inline void write_seqcount_barrier(seqcount_t *s)
>  #define write_sequnlock_bh(lock)                                       \
>        do { write_sequnlock(lock); local_bh_enable(); } while(0)
>
> +#define read_seqbegin_irqsave(lock, flags)                             \
> +       ({ local_irq_save(flags);   read_seqbegin(lock); })
> +
> +#define read_seqretry_irqrestore(lock, iv, flags)                      \
> +       ({                                                              \
> +               int ret = read_seqretry(lock, iv);                      \
> +               local_irq_restore(flags);                               \
> +               ret;                                                    \
> +       })
> +
>  #endif /* __LINUX_SEQLOCK_H */
> --

Does this really need to be reverted? I don't believe the other
reverts make use of these functions either. Looking upstream ,they are
also not used here, so the original patch should be pushed upstream if
anything.

Thanks

John
