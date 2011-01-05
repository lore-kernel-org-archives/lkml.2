Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1AEAO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:14:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab1AEAOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:14:54 -0500
Date: Tue, 4 Jan 2011 16:14:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Subject: Re: [resend][PATCH] fs: use kernel's hex_to_bin() method
Message-Id: <20110104161439.f30ab73c.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=FpimZ=KS7Qgf8PyZ5jG4_74UG6vA9V+CX6MYD@mail.gmail.com>
References: <1291978505-29076-1-git-send-email-andy.shevchenko@gmail.com>
	<20110104152100.29d0da02.akpm@linux-foundation.org>
	<AANLkTi=FpimZ=KS7Qgf8PyZ5jG4_74UG6vA9V+CX6MYD@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011 01:58:56 +0200
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Wed, Jan 5, 2011 at 1:21 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > After which we can change your patch thusly:
> >
> > --- a/fs/binfmt_misc.c~fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix
> > +++ a/fs/binfmt_misc.c
> > @@ -244,9 +244,7 @@ static int unquote(char *from)
> >
> >        while ((c = *s++) != '\0') {
> >                if (c == '\\' && *s == 'x') {
> > -                       s++;
> > -                       *p = hex_to_bin(*s++) << 4;
> > -                       *p++ |= hex_to_bin(*s++);
> > +                       s = (char *)hex2bin(p, s + 1, 1);
> We need to update both p and s.
> 
> In case of '\xAA\xBB' you have result -> '0xBB'.
> Am I wrong?
> 
> >                        continue;
> >                }
> >                *p++ = c;

I'm more into shopping and nagging at people than this programming
thingy.  Sigh.

--- a/fs/binfmt_misc.c~fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix
+++ a/fs/binfmt_misc.c
@@ -243,11 +243,10 @@ static int unquote(char *from)
 	char c = 0, *s = from, *p = from;
 
 	while ((c = *s++) != '\0') {
-		if (c == '\\' && *s == 'x') {
-			s = (char *)hex2bin(p, s + 1, 1);
-			continue;
-		}
-		*p++ = c;
+		if (c == '\\' && *s == 'x')
+			s = (char *)hex2bin(p++, s + 1, 1);
+		else
+			*p++ = c;
 	}
 	return p - from;
 }
_


How does one test this thing?
