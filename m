Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0KUAD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:03:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895Ab0KUAD6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:03:58 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011202127131.24071@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>
 <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com>
 <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
 <AANLkTim1MChiEa9rBL0ZfSCak6G2x4ivK47Svd6swEBS@mail.gmail.com> <alpine.LNX.2.00.1011202127131.24071@swampdragon.chaosbits.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Nov 2010 16:03:35 -0800
Message-ID: <AANLkTi=_r2YvDv0wj6qY_DqXntvHwfKNavTv8AKF+iXm@mail.gmail.com>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer derefs
 in scsi_error.c and reduce size as well
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Anderson <andmike@us.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 12:30 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>
> Ok, I tried doing that (see patch below)

Actually, you kind of chose exactly the reverse of the functions I'd
have chosen.

Try doing the added parameter to the small static helper functions.
Those are the ones that tend to get inlined, and then the parameter
should actually result in _fewer_ pointer reloads.

So the ones like this:

>  static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
>  {
> -       if (!scmd->device->host->hostt->eh_abort_handler)
> +       struct scsi_host_template *hostt = scmd->device->host->hostt;
> +       if (!hostt->eh_abort_handler)
>                return FAILED;
> -
> -       return scmd->device->host->hostt->eh_abort_handler(scmd);
> +       return hostt->eh_abort_handler(scmd);
>  }

Where the function is trivial, and almost all it does is to just
dereference those pointers.

If that function got the "host" pointer as an argument, it should make
it much smaller. Because half of that function is that
"scmd->device->host" lookup.

(ok, that's exaggerated, but not by much).

                Linus
