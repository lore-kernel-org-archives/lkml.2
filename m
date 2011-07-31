Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1GaWSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:18:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:42125 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1GaWSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:18:24 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Date: Sun, 31 Jul 2011 23:18:16 +0100
In-Reply-To: <CACqU3MUJ=B-VszESWcFXbW=TLRxz5HrAaUn3nkyydX-xBBTXhg@mail.gmail.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	 <1312067670.22074.61.camel@i7.infradead.org>
	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	 <4E34998D.8060806@zytor.com>
	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	 <4E34A1E4.8040103@zytor.com>
	 <CACqU3MVkLXoBq7KP2Jff=p7EiKR7DkPa4z7y0Rdah-dGzRvj4g@mail.gmail.com>
	 <4E34AFAD.90008@zytor.com>
	 <CACqU3MUJ=B-VszESWcFXbW=TLRxz5HrAaUn3nkyydX-xBBTXhg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312150698.18010.21.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-30 at 22:09 -0400, Arnaud Lacombe wrote:
> Btw, `make CONFIG_GENERIC_BUG=n oldconfig' or `make CONFIG_64BIT=n
> oldconfig'[0] does not even work, and I'm getting no error. So either
> you make it work for all possible uses, or you warn the user he tried
> something illegal, but you don't just fail silently. 

You're absolutely right that we should report it. I'm dubious about
trying to report a *reason*... it would be nice if we could do it
*reliably*, but we don't actually pass the reasons back up so the code
has to guess. I'm torn between ripping it out because it's guessing, and
trying to improve it. What do you think?

I'd *love* to be able to say 'You need to enable CONFIG_SATA in order to
enable CONFIG_SATA_MV'. But if I were to do *that* then I'd probably end
up ripping out the whole of this 'select' atrocity (which would now have
no excuse for its existence) and I'd be even further from the simple
task I started off with :)

[dwmw2@i7 linux-2.6]$ make CONFIG_GENERIC_BUG=n oldconfig
scripts/kconfig/conf --oldconfig Kconfig
#
# Could not set CONFIG_GENERIC_BUG=n; perhaps it is selected by another option?
#
#
# configuration written to .config
#
[dwmw2@i7 linux-2.6]$ make CONFIG_SATA_MV=y oldconfig
scripts/kconfig/conf --oldconfig Kconfig
#
# Could not set CONFIG_SATA_MV=y; perhaps it has unmet dependencies?
#
#
# configuration written to .config
#


Incremental patch: 

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 0341254..ff25669 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -364,8 +364,22 @@ void conf_set_symbol_from_env(char *str)
 		return;
 
 	sym_calc_value(sym);
-	if (!sym_set_string_value(sym, p))
+	if (!sym_set_string_value(sym, p)) {
+		char *reason;
+
+		if ((sym->type == S_BOOLEAN || sym->type == S_TRISTATE) &&
+			 !p[1] && toupper(p[0]) == 'N')
+			/* We were turning it *off* and failed... selected? */
+			reason = "perhaps it is selected by another option?";
+		else if (!sym->visible)
+			reason = "perhaps it has unmet dependencies?";
+		else
+			reason = "perhaps your setting was invalid?";
+
+		conf_message("Could not set " CONFIG_ "%s=%s; %s",
+			     sym->name, p, reason);
 		return;
+	}
 
 	conf_message(CONFIG_ "%s set to %s from environment", sym->name, p);
 	if (sym_is_choice_value(sym))

-- 
dwmw2

