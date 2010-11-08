Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab0KHQ4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:56:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37843 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab0KHQ4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:56:03 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 8 Nov 2010 11:55:40 -0500
X-Google-Sender-Auth: oCGqr1_FLr5HtTvWFLCfFZXGFYY
Message-ID: <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 3:30 PM, Oren Laadan <orenl@cs.columbia.edu> wrote:
> Hi,
>
> Following the discussion yesterday, here is a linux-cr diff that
> that is limited to changes to existing code.
>
> The diff doesn't include the eclone() patches. I also tried to strip
> off the new c/r code (either code in new files, or new code within
> #ifdef CONFIG_CHECKPOINT in existing files).
>
> I left a few such snippets in, e.g. c/r syscalls templates and
> declaration of c/r specific methods in, e.g. file_operations.
>
> The remaining changes in this patch include new freezer state
> ("CHECKPOINTING"), mostly refactoring of exsiting code, and a bit
> of new helpers.
>
> Disclaimer: don't try to compile (or apply) - this is only intended
> to give a ballpark of how the c/r patches change existing code.
[...]
>  159 files changed, 2031 insertions(+), 587 deletions(-)

FWIW...

This patch has far reaching changes which quite frankly scare me;
primarily because c/r changes many long-held assumptions about how
Linux processes work.  It needs to track a large amount of state with
lots of corner cases, and the Linux process model is already quite
complex.  I know this is a fluffy hand-waving critique, but without
being convinced of a strong general-purpose use-case, it is hard to
get excited about a solution that touches large amounts of common
code.

c/r of desktop processes doesn't seem interesting other that as a test
case, but I can possibly be convinced about HPC, embedded, industrial,
or telecom use-cases, but for custom/specific-purpose applications the
question must be asked if a fully user space or joint user/kernel
method would better solve the problem.

You mentioned in a reply that this overview diff includes both
cleanups and required changes.  I suggest posting the cleanup patches
as soon as possible so that this diff becomes simpler.

Also:

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 9458685..335a4b3 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -93,6 +93,10 @@ config STACKTRACE_SUPPORT
>  config HAVE_LATENCYTOP_SUPPORT
>        def_bool y
>
> +config CHECKPOINT_SUPPORT
> +       bool
> +       default y
> +

Definitely should not default to 'y', and needs to be user-selectable.

g.
