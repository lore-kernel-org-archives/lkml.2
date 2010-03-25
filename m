Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0CYE7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 00:59:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55486 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0CYE7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 00:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=sRhUY/nDxcsfGZ2MolK8/pnn8dJ6ueZmp/Ji5D5/S9XO4CNyEUn04ZyM38AJFz/8t9
         gGB2ww/f6X5LfdRsr9ERfVr++7wKhf8ifhZwar2lEhSK65C48qnLutyV5I+TL9EdAZFd
         VpbvzRPVtEJ3Q+xusS+hinfU6TpIzF4dAdGJg=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the kgdb tree
Date: Wed, 24 Mar 2010 21:59:25 -0700
User-Agent: KMail/1.13.1 (Linux/2.6.34-rc2; KDE/4.4.1; x86_64; ; )
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100323150443.608ad7f0.sfr@canb.auug.org.au> <20100325154307.9cdeae10.sfr@canb.auug.org.au>
In-Reply-To: <20100325154307.9cdeae10.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003242159.25770.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010 09:43:07 pm Stephen Rothwell wrote:
> Hi Jason, Dmitry,
> 
> On Tue, 23 Mar 2010 15:04:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au> 
wrote:
> > After merging the kgdb tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > kernel/debug/kdb/kdb_main.c: In function 'kdb_sr':
> > kernel/debug/kdb/kdb_main.c:1822: error: '__sysrq_enabled' undeclared
> > (first use in this function)
> > 
> > Caused by commit ab28988df9667f8dd70c7434c8ca463beb00b300 ("kdb: core for
> > kgdb back end (1 of 2)") from the kgdb tree interacting with commit
> > edc6e384f9d96e54a6d03068d3b03fa5b56b6449 ("") fromInput: implement SysRq
> > as a separate input handler the input tree.
> 
> I got this again today (I stopped reverting the input tree commits that I
> was reverting for another build problem).  The patch below still seems to
> work OK.

Yes, I  of __sysrq_enabled is not global anymore...

I am not sure I like kgdb enabling sysrq functonality on its own, I'd rather
export __handle_sysrq that does not check sysrq state...

> 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Tue, 23 Mar 2010 14:45:22 +1100
> > Subject: [PATCH] kgdb: update for sysrq handling change
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> > 
> >  kernel/debug/kdb/kdb_main.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
> > index f1f9309..bad8e63 100644
> > --- a/kernel/debug/kdb/kdb_main.c
> > +++ b/kernel/debug/kdb/kdb_main.c
> > @@ -1819,10 +1819,8 @@ static int kdb_sr(int argc, const char **argv)
> > 
> >  {
> >  
> >  	if (argc != 1)
> >  	
> >  		return KDB_ARGCOUNT;
> > 
> > -	if (!__sysrq_enabled) {
> > -		kdb_printf("Auto activating sysrq\n");
> > -		__sysrq_enabled = 1;
> > -	}
> > +
> > +	sysrq_toggle_support(1);
> > 
> >  	kdb_trap_printk++;
> >  	handle_sysrq(*argv[1], NULL);

Thanks.

-- 
Dmitry
