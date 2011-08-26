Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1HZHV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:21:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab1HZHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:21:27 -0400
Date: Fri, 26 Aug 2011 09:21:24 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2011-08-24-14-08 uploaded
Message-ID: <20110826072124.GB7280@tiehlicka.suse.cz>
References: <201108242148.p7OLm1lt009191@imap1.linux-foundation.org>
 <20110825135103.GA6431@tiehlicka.suse.cz>
 <20110825140701.GA6838@tiehlicka.suse.cz>
 <20110826010938.5795e43137d58c9f42d44458@canb.auug.org.au>
 <20110825154538.GA5860@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825154538.GA5860@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25-08-11 17:45:38, Johannes Weiner wrote:
> On Fri, Aug 26, 2011 at 01:09:38AM +1000, Stephen Rothwell wrote:
> > Hi,
> > 
> > On Thu, 25 Aug 2011 16:07:01 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> > >
> > > On Thu 25-08-11 15:51:03, Michal Hocko wrote:
> > > > 
> > > > On Wed 24-08-11 14:09:05, Andrew Morton wrote:
> > > > > The mm-of-the-moment snapshot 2011-08-24-14-08 has been uploaded to
> > > > > 
> > > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > > 
> > > > I have just downloaded your tree and cannot quilt it up. I am getting:
> > > > [...]
> > > > patching file tools/power/cpupower/debug/x86_64/centrino-decode.c
> > > > Hunk #1 FAILED at 1.
> > > > File tools/power/cpupower/debug/x86_64/centrino-decode.c is not empty after patch, as expected
> > > > 1 out of 1 hunk FAILED -- rejects in file tools/power/cpupower/debug/x86_64/centrino-decode.c
> > > > patching file tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
> > > > Hunk #1 FAILED at 1.
> > > > File tools/power/cpupower/debug/x86_64/powernow-k8-decode.c is not empty after patch, as expected
> > > > 1 out of 1 hunk FAILED -- rejects in file tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
> > > > [...]
> > > > patching file virt/kvm/iommu.c
> > > > Patch linux-next.patch does not apply (enforce with -f)
> > > > 
> > > > Is this a patch (I am using 2.6.1) issue? The failing hunk looks as
> > > > follows:
> > > > --- a/tools/power/cpupower/debug/x86_64/centrino-decode.c
> > > > +++ /dev/null
> > > > @@ -1 +0,0 @@
> > > > -../i386/centrino-decode.c
> > > > \ No newline at end of file
> > > 
> > > Isn't this just a special form of git (clever) diff to spare some lines
> > > when the file deleted? Or is the patch simply corrupted?
> > > Anyway, my patch doesn't cope with that. Any hint what to do about it?
> > 
> > Those files were symlinks and were removed by a commit in linux-next.
> > diff/patch does not cope with that.

Ahh, symlinks. I had a feeling that I had already seen a diff like that.

> You can probably replace `patch' in your $PATH by a wrapper that uses
> git-apply, which can deal with them.
> 
> Or you could use git-quiltimport, which uses git-apply, to prepare the
> -mmotm base tree in git, on top of which you can continue to work with
> quilt.

Thanks for hints!

> 
> I do this with a cron-job automatically, you can find the result here:
> 
>     http://git.kernel.org/?p=linux/kernel/git/hannes/linux-mmotm.git;a=summary

I was more interested in integration to our SuSE kernel tree to have
easier life with rpm creation and stuff (and we use quilt to build the
source tree). Anyway the above should be suffiecient to go on.

> 
> If you want to do it manually, there is sometimes confusing binary
> file patch sections in -mmotm, which in turn git-apply can not deal
> with, so I use the following uncrapdiff.awk filter on the patches
> before import.
> 
> ---
> 
> # Filter out sections that feature an index line but
> # no real diff part that would start with '--- file'
> 
> {
> 	if (HEADER ~ /^diff --git /) {
> 		if ($0 ~ /^index /) {
> 			INDEX=$0
> 		} else if ($0 ~ /^diff --git /) {
> 			print(HEADER)
> 			HEADER=$0
> 		} else if (INDEX ~ /^index /) {
> 			if ($0 ~ /^--- /) {
> 				print(HEADER)
> 				print(INDEX)
> 				print($0)
> 			}
> 			HEADER=""
> 			INDEX=""
> 		} else {
> 			HEADER=HEADER "\n" $0
> 		}
> 	} else if ($0 ~ /^diff --git /) {
> 		HEADER=$0
> 	} else {
> 		print($0)
> 	}
> }
> 
> ---
> 
> HTH

Definitely did.

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
