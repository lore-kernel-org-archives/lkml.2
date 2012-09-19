Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab2ISUIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:08:06 -0400
Received: from fieldses.org ([174.143.236.118]:41187 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2ISUIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:08:04 -0400
Date: Wed, 19 Sep 2012 16:07:59 -0400
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: IMA policy search speedup
Message-ID: <20120919200759.GA2169@fieldses.org>
References: <CALLzPKZqw05_4V6NQeo-A6xOza2P4g6mqxDJnv7f-ktovj_HpQ@mail.gmail.com>
 <alpine.LRH.2.02.1209191419410.29525@tundra.namei.org>
 <CALLzPKaKoHkVx37FeOSTpRvFM_d6KifDYvywbMk4MOKiy2nQbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKaKoHkVx37FeOSTpRvFM_d6KifDYvywbMk4MOKiy2nQbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 01:25:26PM +0300, Kasatkin, Dmitry wrote:
> On Wed, Sep 19, 2012 at 7:21 AM, James Morris <jmorris@namei.org> wrote:
> > On Tue, 18 Sep 2012, Kasatkin, Dmitry wrote:
> >
> >> I looked to <linux/fs.h> and found that there is a possibility to to
> >> add additional flag for sb->s_flags.
> >> For example
> >>
> >> #define MS_NOT_IMA              (1<<25) /* NOT_IMA */
> >> #define IS_I_NOT_IMA(inode)   __IS_FLG(inode, MS_NOT_IMA)
> >>
> >>
> >> Another way is to add additional dedicated integrity related member to
> >> the sb structure.
> >> struct super_block {
> >> ...
> >> #ifdef CONFIG_INTEGRITY
> >>       int s_integrity;
> >> #endif
> >> };
> >>
> >> Obviously there are only few super blocks in the system and few bytes
> >> will not harm.
> >
> > The flag seems better than adding a new struct member.  Why would you need
> > an int for this?
> >
> 
> int is not really needed. It may be char. I just thought that normally
> we have around 10 super blocks
> and it 10 or 40 bytes does not really mater...

Maybe not, but if you use something more generic

	unsigned int s_feature_flags
	#define SF_IMA_ENABLED

then there'd be more uses for that field.

(Two that nfsd would use:
	- does this filesystem support a changeattribute?  (currently a
	  mount flag but that doesn't really make sense in general)
	- is this filesystem case-insensitive?  (whatever that means)
)

--b.

> 
> Actually there is more severe case. IMA cache objects "iint" per inode
> have following members:
>   enum integrity_status ima_status;
>   enum integrity_status evm_status;
> 
> And it is only 5 values per each or 10 values per 8 bytes.
> 8 bytes can be easily replaced by 1 byte.
> 
> Should we improve it?
> 
> >
> >
> > - James
> > --
> > James Morris
> > <jmorris@namei.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
