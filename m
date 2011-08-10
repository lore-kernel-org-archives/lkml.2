Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1HJXRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:17:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:36407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab1HJXRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:17:30 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Thu, 11 Aug 2011 00:16:49 +0100
In-Reply-To: <CACqU3MU2J25q-wWJ8LNcMkwi3uMigz_+0=XcrNiPC0TGiJHZqA@mail.gmail.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	 <1312067670.22074.61.camel@i7.infradead.org>
	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	 <4E34998D.8060806@zytor.com>
	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	 <4E4140B3.7090802@suse.cz>
	 <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
	 <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org>
	 <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
	 <1312985888.2989.46.camel@i7.infradead.org>
	 <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>
	 <1312993987.2989.53.camel@i7.infradead.org>
	 <CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>
	 <1312999168.2989.61.camel@i7.infradead.org>
	 <CACqU3MWB+4n5Acd-GboH5WbCzfZFiAc0wNvOkn_5O+--7jLE8A@mail.gmail.com>
	 <1313002322.2989.88.camel@i7.infradead.org>
	 <CACqU3MU2J25q-wWJ8LNcMkwi3uMigz_+0=XcrNiPC0TGiJHZqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313018232.2989.114.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 18:33 -0400, Arnaud Lacombe wrote:
> > We're not enabling anything that we're later going to break. I can't see
> > many people *depending* on the fact that 'make CONFIG_SATA_MV=y
> > oldconfig' actually does *nothing* in some cases.
> >
> you are wrong, you ends up with half-baked compile-time dependency,
> which break the build:

s/*nothing*/nothing useful/, for crying out loud.

The point remains that we're not enabling anything which we're later
going to break. Nobody is going to come to *depend* on this behaviour.

And anyway, this behaviour exists even *before* my patches, as Michal
pointed out in a far more helpful and constructive fashion in 
<CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
earlier today.

It's simple enough to fix, too:

diff --git a/Makefile b/Makefile
index 1fc5172..6cc7f7b 100644
--- a/Makefile
+++ b/Makefile
@@ -474,6 +474,9 @@ ifeq ($(KBUILD_EXTMOD),)
         endif
 endif
 
+# This could probably be simpler?
+CONFIG_OVERRIDES := $(patsubst line:%,%,$(filter line:%,$(foreach var, $(filter CONFIG_%,$(.VARIABLES)), $(origin $(var)):$(var))))
+
 ifeq ($(mixed-targets),1)
 # ===========================================================================
 # We're called with mixed targets (*config and build targets).
@@ -507,6 +510,10 @@ else
 # Build targets only - this includes vmlinux, arch specific targets, clean
 # targets and others. In general all targets except *config targets.
 
+ifneq ($(CONFIG_OVERRIDES),)
+$(error Cannot perform build targets with CONFIG symbols overridden)
+endif
+
 ifeq ($(KBUILD_EXTMOD),)
 # Additional helpers built in scripts/
 # Carefully list dependencies so we do not try to build scripts twice


-- 
dwmw2

