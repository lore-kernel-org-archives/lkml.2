Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2A0Uej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:34:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2A0Uej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:34:39 -0500
Date: Fri, 27 Jan 2012 12:34:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/5] x86/jump-label: Do not bother updating nops if they
 are correct
Message-Id: <20120127123437.481791ba.akpm@linux-foundation.org>
In-Reply-To: <20120127202031.234193929@goodmis.org>
References: <20120127201442.080360013@goodmis.org>
	<20120127202031.234193929@goodmis.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012 15:14:44 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -53,7 +53,25 @@ void arch_jump_label_transform(struct jump_entry *entry,
>  void arch_jump_label_transform_static(struct jump_entry *entry,
>  				      enum jump_label_type type)
>  {
> -	__jump_label_transform(entry, type, text_poke_early);
> +	static int once;
> +	static int update;
> +
> +	/*
> +	 * This function is called at boot up and when modules are
> +	 * first loaded. Check if the default nop, the one that is
> +	 * inserted at compile time, is the ideal nop. If it is, then
> +	 * we do not need to update the nop, and we can leave it as is.
> +	 * If it is not, then we need to update the nop to the ideal nop.
> +	 */
> +	if (!once) {
> +		unsigned char default_nop[] = { JUMP_LABEL_INIT_NOP };

const.  It generates less code.  With my compiler version, at least. 
That was a bit dumb of it, given that memcmp() is declared to take
const args.

> +		const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
> +		once++;
> +		if (memcmp(ideal_nop, default_nop, 5) != 0)
> +			update = 1;
> +	}
> +	if (update)
> +		__jump_label_transform(entry, type, text_poke_early);
>  }
