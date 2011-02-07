Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab1BGJmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 04:42:04 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59968 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BGJmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 04:42:01 -0500
Date: Mon, 7 Feb 2011 10:43:46 +0100
From: Borislav Petkov <bp@amd64.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 16/52] kstrtox: convert drivers/edac/
Message-ID: <20110207094346.GB21590@aftab>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
 <1296915654-7458-16-git-send-email-adobriyan@gmail.com>
 <20110205173449.GA31845@liondog.tnic>
 <20110206185252.GA6439@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110206185252.GA6439@p183.telecom.by>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 01:52:52PM -0500, Alexey Dobriyan wrote:
> On Sat, Feb 05, 2011 at 06:34:49PM +0100, Borislav Petkov wrote:
> > On Sat, Feb 05, 2011 at 04:20:19PM +0200, Alexey Dobriyan wrote:
> > 
> > Some kind of a boilerplate commit message is still better than none at all.
> > 
> > > 
> > > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > > ---
> > >  drivers/edac/amd64_edac_inj.c |  135 +++++++++++++++++------------------------
> > >  drivers/edac/edac_mc_sysfs.c  |   20 +++---
> > >  drivers/edac/i7core_edac.c    |   41 +++++++------
> > >  drivers/edac/mce_amd_inj.c    |   28 ++++-----
> > >  4 files changed, 101 insertions(+), 123 deletions(-)
> > > 
> > > diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
> > > index 688478d..180a498 100644
> > > --- a/drivers/edac/amd64_edac_inj.c
> > > +++ b/drivers/edac/amd64_edac_inj.c
> > > @@ -16,21 +16,18 @@ static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
> > >  					  const char *data, size_t count)
> > >  {
> > >  	struct amd64_pvt *pvt = mci->pvt_info;
> > > -	unsigned long value;
> > > -	int ret = 0;
> > > -
> > > -	ret = strict_strtoul(data, 10, &value);
> > > -	if (ret != -EINVAL) {
> > > -
> > > -		if (value > 3) {
> > > -			amd64_warn("%s: invalid section 0x%lx\n", __func__, value);
> > > -			return -EINVAL;
> > > -		}
> > > -
> > > -		pvt->injection.section = (u32) value;
> > > -		return count;
> > > +	u32 value;
> > > +	int ret;
> > > +
> > > +	ret = kstrtou32(data, 10, &value);
> > > +	if (ret < 0)
> > > +		return ret;
> > 
> > newline here
> 
> A what? Why?

Hmm, let me see, better readability.

> 
> > > @@ -107,29 +98,22 @@ static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
> > >  					const char *data, size_t count)
> > >  {
> > >  	struct amd64_pvt *pvt = mci->pvt_info;
> > > -	unsigned long value;
> > >  	u32 section, word_bits;
> > > -	int ret = 0;
> > > -
> > > -	ret = strict_strtoul(data, 10, &value);
> > > -	if (ret != -EINVAL) {
> > 
> > Dropping those would mean that the injection read (and write) below
> > would happen on any value written.
> 
> Yes, since the value written is unused, and all data were already
> written via other files.
> 
> > Let's keep them and enforce a write
> > of '1' to be only valid injection trigger like the rest of the /sysfs
> > interfaces:
> 
> Right now, any number will do, so in fact it'd be better to use kstrtoul().

Ok, let's accept only a "1" though.

> 
> > 	ret = kstrtou8(data, 10, &value);
> > 	if (ret < 0)
> > 		return ret;
> > 
> > 	if (value != 1)
> > 		return -EINVAL;
> > > @@ -197,17 +174,15 @@ struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
> > >  	{
> > >  		.attr = {
> > >  			.name = "inject_write",
> > > -			.mode = (S_IRUGO | S_IWUSR)
> > > +			.mode = S_IWUSR,
> > 
> > This change is not mentioned anywhere, why do we need it?
> 
> File is write-only. I'll mention this in changelog.

Ok, actually, come to think of it, it would be even better if it would
show what values are written to the injection registers so I'll supply
->show methods for them. You can drop this hunk changing file perms from
your patch.

Thanks.


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
