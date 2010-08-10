Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab0HJSbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:31:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:55001 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab0HJSbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:31:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,349,1278313200"; 
   d="scan'208";a="310375896"
Date: Tue, 10 Aug 2010 11:31:35 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: tpmdd-devel@lists.sourceforge.net,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: TPM bug fix causes hang on suspend (2.6.35-rc4)
Message-ID: <20100810183135.GD2358@xanatos>
References: <20100717000033.GA2509@xanatos>
 <1279375943.4731.0.camel@localhost.localdomain>
 <20100719170541.GA3004@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100719170541.GA3004@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 10:05:41AM -0700, Sarah Sharp wrote:
> On Sat, Jul 17, 2010 at 04:12:23PM +0200, Thomas Meyer wrote:
> > Am Freitag, den 16.07.2010, 17:00 -0700 schrieb Sarah Sharp:
> > > I recently upgraded to 2.6.35-rc4, and I discovered that suspend no
> > > longer works on my Thinkpad x200s.  When I suspend with some programs
> > > open (specifically while buffy is reading my maildirs), the suspend
> > > light blinks forever and the system never suspends.
> > > 
> > > I bisected the issue down to commit b5edfef, which is a merge of James
> > > Morris' security-testing-2.6 tree, that only included this commit:
> > > 
> > > commit 02a077c52ef7631275a79862ffd9f3dbe9d38bc2
> > > Author: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> > > Date:   Mon Jun 14 13:58:22 2010 -0300
> > > 
> > >     TPM: ReadPubEK output struct fix
> > >     
> > >     This patch adds a missing element of the ReadPubEK command output,
> > >     that prevents future overflow of this buffer when copying the
> > >     TPM output result into it.
> > >     
> > >     Prevents a kernel panic in case the user tries to read the
> > >     pubek from sysfs.
> > >     
> > >     Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> > >     Signed-off-by: James Morris <jmorris@namei.org>
> > > 
> > > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > > index 8e00b4d..792868d 100644
> > > --- a/drivers/char/tpm/tpm.h
> > > +++ b/drivers/char/tpm/tpm.h
> > > @@ -224,6 +224,7 @@ struct      tpm_readpubek_params_out {
> > >         u8      algorithm[4];
> > >         u8      encscheme[2];
> > >         u8      sigscheme[2];
> > > +       __be32  paramsize;
> > >         u8      parameters[12]; /*assuming RSA*/
> > >         __be32  keysize;
> > >         u8      modulus[256];
> > > 
> > > The dmesg captured over netconsole when suspend fails is attached, but
> > > it doesn't look very interesting.  lspci output is also attached.  I
> > > don't have any userspace programs installed that can use TPM, like
> > > trousers or libtspi1.
> > > 
> > > If I try just removing the tpm_tis, tpm_bios, and tpm modules before
> > > suspending, the suspend still fails.  If I recompile without TPM
> > > hardware support (CONFIG_TCG_TPM=n), suspend still fails.  However, if I
> > > also turn off the securityFS config option (CONFIG_SECURITYFS),
> > > suspend succeeds.
> > > 
> > > It looks like an odd commit to cause a suspend failure, but when I reset
> > > the git HEAD to the commit before the merge of this patch, and suspend
> > > works fine.  Can you fix this?
> > > 
> > > Sarah Sharp
> > 
> > Maybe same as https://bugzilla.kernel.org/show_bug.cgi?id=16256 ?
> 
> That doesn't look really similar.  The user found a different patch at
> fault, and they were also able to successfully suspend when the tpm_tis
> module was removed, but suspend still breaks for me in that case.
> Suspend breaks with that commit even when I don't compile any tpm
> modules at all.  But I'll try Helmut's fix[1] and let you know if it
> works.

I tried the fix, and all seemed well for a while.  Then suspend randomly
broken again.  I've tried to update to 2.6.35, but I have the same issue
(constant blinking suspend light and the suspend never completes).

Sarah Sharp
