Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1BFSxC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:53:02 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44028 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab1BFSxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:53:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hvMtb4KAvlVciabFiE341fUQJJ356VIm0Y0kdN7hwYjQVlZUk9jKw9682W7hOL45EK
         grxy197enIku7XDHRGyaJrAZ5HL9aUDBitQNp9uhYI7pG9ShLzOZJVEsvvk1grdi784b
         FQt6I9kXF7DokJGpaxAbzyPzq8RyvH69JoC7U=
Date: Sun, 6 Feb 2011 20:52:52 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Borislav Petkov <bp@alien8.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, borislav.petkov@amd.com
Subject: Re: [PATCH 16/52] kstrtox: convert drivers/edac/
Message-ID: <20110206185252.GA6439@p183.telecom.by>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
 <1296915654-7458-16-git-send-email-adobriyan@gmail.com>
 <20110205173449.GA31845@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205173449.GA31845@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 06:34:49PM +0100, Borislav Petkov wrote:
> On Sat, Feb 05, 2011 at 04:20:19PM +0200, Alexey Dobriyan wrote:
> 
> Some kind of a boilerplate commit message is still better than none at all.
> 
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> >  drivers/edac/amd64_edac_inj.c |  135 +++++++++++++++++------------------------
> >  drivers/edac/edac_mc_sysfs.c  |   20 +++---
> >  drivers/edac/i7core_edac.c    |   41 +++++++------
> >  drivers/edac/mce_amd_inj.c    |   28 ++++-----
> >  4 files changed, 101 insertions(+), 123 deletions(-)
> > 
> > diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
> > index 688478d..180a498 100644
> > --- a/drivers/edac/amd64_edac_inj.c
> > +++ b/drivers/edac/amd64_edac_inj.c
> > @@ -16,21 +16,18 @@ static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
> >  					  const char *data, size_t count)
> >  {
> >  	struct amd64_pvt *pvt = mci->pvt_info;
> > -	unsigned long value;
> > -	int ret = 0;
> > -
> > -	ret = strict_strtoul(data, 10, &value);
> > -	if (ret != -EINVAL) {
> > -
> > -		if (value > 3) {
> > -			amd64_warn("%s: invalid section 0x%lx\n", __func__, value);
> > -			return -EINVAL;
> > -		}
> > -
> > -		pvt->injection.section = (u32) value;
> > -		return count;
> > +	u32 value;
> > +	int ret;
> > +
> > +	ret = kstrtou32(data, 10, &value);
> > +	if (ret < 0)
> > +		return ret;
> 
> newline here

A what? Why?

> > @@ -107,29 +98,22 @@ static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
> >  					const char *data, size_t count)
> >  {
> >  	struct amd64_pvt *pvt = mci->pvt_info;
> > -	unsigned long value;
> >  	u32 section, word_bits;
> > -	int ret = 0;
> > -
> > -	ret = strict_strtoul(data, 10, &value);
> > -	if (ret != -EINVAL) {
> 
> Dropping those would mean that the injection read (and write) below
> would happen on any value written.

Yes, since the value written is unused, and all data were already
written via other files.

> Let's keep them and enforce a write
> of '1' to be only valid injection trigger like the rest of the /sysfs
> interfaces:

Right now, any number will do, so in fact it'd be better to use kstrtoul().

> 	ret = kstrtou8(data, 10, &value);
> 	if (ret < 0)
> 		return ret;
> 
> 	if (value != 1)
> 		return -EINVAL;
> > @@ -197,17 +174,15 @@ struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
> >  	{
> >  		.attr = {
> >  			.name = "inject_write",
> > -			.mode = (S_IRUGO | S_IWUSR)
> > +			.mode = S_IWUSR,
> 
> This change is not mentioned anywhere, why do we need it?

File is write-only. I'll mention this in changelog.

> > -		.show = NULL,
> >  		.store = amd64_inject_write_store,
> >  	},
> >  	{
> >  		.attr = {
> >  			.name = "inject_read",
> > -			.mode = (S_IRUGO | S_IWUSR)
> > +			.mode = S_IWUSR,

