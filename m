Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0DNGwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:52:40 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:45533 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab0DNGwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YLrokkhr9eUuLHQtXjYX/ebliZNmSpwGt84HbNnUfTtpvCKf14MZv2dyxuN3i6tkVe
         Ulz0bxRds/C7ysEK0TMoiG5yUyGVptOrJj2brQebYPAkK4vCUekk7EmoOzbfn9RFlPMu
         EExLmVZYK3ZuoqFda6f3sAuyLyJuGHzNijoCA=
MIME-Version: 1.0
In-Reply-To: <p2q121039231004132344pae57964atbd6587f6ed38c471@mail.gmail.com>
References: <x2i121039231004132342sa230bfd4k832950fce534113f@mail.gmail.com>
	 <p2q121039231004132344pae57964atbd6587f6ed38c471@mail.gmail.com>
Date: Wed, 14 Apr 2010 12:16:56 +0530
Message-ID: <o2h121039231004132346q558648d5k55ea6f733f4ba871@mail.gmail.com>
Subject: DMA Engine API performance issues
From: melwyn lobo <linux.melwyn@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject edited to allow posting on ARM kernel list

On Wed, Apr 14, 2010 at 12:14 PM, melwyn lobo <linux.melwyn@gmail.com> wrote:
> Forwarding the query also to arm kernel mailiing list.
>
> Regards,
> M.
>
>
> ---------- Forwarded message ----------
> From: melwyn lobo <linux.melwyn@gmail.com>
> Date: Wed, Apr 14, 2010 at 12:12 PM
> Subject: DMA Engine API performance issues
> To: dan.j.williams@intel.com, linux-arm-kernel@lists.arm.linux.org.uk,
> linux-kernel@vger.kernel.org
>
>
> Hello Dan,
> I have some doubts regarding DMA API usage on its clients for example
> MMC, ALSA, USB etc.
>
> I am going to take example of the ALSA framework. Audio data transfer
> is initiated in soc_pcm_trigger(). This is called in an atomic
> context,
> with spinlock held and irqs disabled. Here most drivers enable data
> transfer from the MSP peripheral to the audio codec via tx_submit
> implementation
> of the DMA engine driver. This enqueues the transaction in an active
> list which calls for using spinlocks with bottom half disabled.
> It is in this function when spin_unlock_bh() is called the kernel
> detects irq's disabled and generates a warning.
> So the workaround here for ALSA drivers would be to use tasklet or
> workqueues to defer calling this in an interruptible context, which
> would
> cause performance problems (the same function soc_pcm_trigger is
> called for stoppping the transfer) in cases where the stream has to be
> repeatedly
> stopped and started.
>
> So the core issue is use of spin_unlock_bh in an atomic context.
> Workaround for removing the warnings would be:
> 1. Use spin_lock with irqsave and corresponding unlock function which
> does not generate a warning in a similar situation.
>  But this could be futile in one case where the tasklet is scheduled
> from ksoftirqd which could lead to corruption.
>  Also this means the interrupts would be disabled (on the local cpu)
> till the function executed which is not something
>  desirable.
> 2. Use local_irq_enable() before calling the DMA APIs and disable once
> done. This is a crude solution and understandably undesirable and
> dangerous.
>
> The DMA Engine framework assumes that the channel interrupt handling
> is done in a tasklet (dma_run_dependencies), which I believe is the
> reason for the issue.
>
> Regards,
> M.
>
