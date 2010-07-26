Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0GZHXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:23:55 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39092 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0GZHXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:23:53 -0400
Date: Mon, 26 Jul 2010 09:23:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: Testing of function/data-sections on linux-2.6.35-rc4
Message-ID: <20100726072350.GA10061@merkur.ravnborg.org>
References: <201007181703.17022.vda.linux@googlemail.com> <20100723191055.GA27054@merkur.ravnborg.org> <201007260252.57477.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007260252.57477.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 02:52:57AM +0200, Denys Vlasenko wrote:
> On Friday 23 July 2010 21:10, Sam Ravnborg wrote:
> > > 
> > > * modpost fix for 64k+ sections: linux-2.6.35-rc4-fs.modpost.patch
> > >   This patch is in -mm, it still not reach mainline...
> > > 
> > 
> > Some comments below - but noting fundamental.
> >
> > +	/* Fixup for more than 64k sections */
> > +	info->num_sections = hdr->e_shnum;
> > +	if (info->num_sections == 0) { /* more than 64k sections? */
> > +		/* note: it doesn't need shndx2secindex() */
> > +		info->num_sections = TO_NATIVE(sechdrs[0].sh_size);
> > +	}
> > I had to read the above twice to get it.
> > How about something like this:
> > 
> > 	/* Fixup for more than 64k sections */
> > 	if (hdr->e_shnum == 0) {
> > 		/*
> > 		 * There are more than 64k sections,
> > 		 * read count from .sh_size.
> > 		 * note: it doesn't need shndx2secindex()
> > 		 */
> > 		info->num_sections = TO_NATIVE(sechdrs[0].sh_size);
> > 	}
> > 	else {
> > 		info->num_sections = hdr->e_shnum;
> > 	}
> > 
> > 
> > +	info->secindex_strings = hdr->e_shstrndx;
> > +	if (info->secindex_strings == SHN_XINDEX)
> > +		info->secindex_strings =
> > +		    shndx2secindex(TO_NATIVE(sechdrs[0].sh_link));
> > 
> > Likewise here...
> 
> Done both.
> 
> ...
> > -	for (i = 1; i < hdr->e_shnum; i++) {
> > -		const char *secstrings
> > -			= (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
> > +	secstrings = (void *)hdr + sechdrs[info->secindex_strings].sh_offset;
> > 
> > Moving this assignnet out of the loop is an unrelated
> > but welcome change.
> 
> I take you are ok with it?
> 
> Please find updated patch below.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

If the patch get a proper changelog then it has my:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
