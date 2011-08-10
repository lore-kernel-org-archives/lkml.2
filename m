Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab1HJNIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:08:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:47039 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1HJNIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:08:00 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Wed, 10 Aug 2011 14:07:36 +0100
In-Reply-To: <4E4280BA.9050109@suse.cz>
References: <1312067499.22074.59.camel@i7.infradead.org>
	 <1312067670.22074.61.camel@i7.infradead.org>
	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	 <4E34998D.8060806@zytor.com>
	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	 <4E4140B3.7090802@suse.cz>
	 <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
	 <4E4280BA.9050109@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312981658.2989.39.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 14:59 +0200, Michal Marek wrote:
> I wasn't talking about the env= syntax, but about
> 
> make CONFIG_EXT2_FS=m all
> which makes kbuild visit fs/ext2 even if CONFIG_EXT2_FS is disabled in
> .config. With no update of the configuration or checking the dependencies.
> 
> Hm, actually this would be a problem even if kconfig does read the
> CONFIG_* variables from the environment, because it could result in a
> mismatch if kconfig determines that the variable cannot be set, but make
> still sees it in the environment. So we would have to use 'undefine
> CONFIG_FOO' instead of '# CONFIG_FOO is not set' in
> include/config/auto.conf, to be able to properly support make CONFIG_FOO=y. 

That's always been true; it's *always* been broken like that.

But now we're actually *encouraging* people to start setting
CONFIG_FOO=y in the environment or the make command line, so we should
certainly make it more robust.

It should be simple enough to force a reconfig if CONFIG_* is specified
in the environment.

Actually, while we're at it let's stop just picking it up from the
environment and pick it up *only* if it's overridden in the make flags.

Something like this will list the variables which are overridden on the
command line:

CONFIG_OVERRIDES := $(patsubst line:%,%,$(filter line:%,$(foreach var, $(filter CONFIG_%,$(.VARIABLES)), $(origin $(var)):$(var))))

Then we can make auto.conf.cmd trigger a reconfig if it's non-empty, and
make the kconfig tool allow overrides *only* for those variables
specified in $CONFIG_OVERRIDES... which avoids any worries about "stray"
environment variables too.

I'll see if I can clean the above expression up and do that.
 
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

