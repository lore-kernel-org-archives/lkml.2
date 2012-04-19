Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2DSWCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:02:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39336 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932522Ab2DSWCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:02:06 -0400
Date: Fri, 20 Apr 2012 02:02:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "matthltc@us.ibm.com" <matthltc@us.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>, Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: +
 c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
 num_exe_file_vmas-removal.patch added to -mm tree
Message-ID: <20120419220201.GR1893@moon>
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com>
 <20120419192005.GA13558@redhat.com>
 <20120419210033.GO1893@moon>
 <20120419211216.GA2200@redhat.com>
 <4F9087D0.60709@openvz.org>
 <20120419215109.GA4896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419215109.GA4896@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 11:51:09PM +0200, Oleg Nesterov wrote:
> On 04/20, Konstantin Khlebnikov wrote:
> >
> > Oleg Nesterov wrote:
> >>
> >> You misunderstood. I am not arguing with "one-shot", I do not really
> >> care.
> >>
> >> My question is: unless I missed something "it can't be changed again"
> >> is not actually true. A task does PR_SET_MM_EXE_FILE, then it forks
> >> the new child. The child can do PR_SET_MM_EXE_FILE again. Is this
> >> by design?
> >>
> >> Oleg.
> >>
> >
> > I found more weird case: child thread (with CLONE_THREAD and without CLONE_VM)
> > changes its exe_file...
> 
> No. copy_process() does:
> 
> 	if ((clone_flags & CLONE_THREAD) && !(clone_flags & CLONE_SIGHAND))
> 		return ERR_PTR(-EINVAL);
> 
> 	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
> 		return ERR_PTR(-EINVAL);
> 
> IOW, CLONE_THREAD => CLONE_SIGHAND => CLONE_VM

Guys, while I more-less agree with Matt about single-shot behaviour

[ let me copy my and his email

  >> With mm->exe_file this prctl option become a one-shot
  >> only, and while at moment our user-space tool can perfectly
  >> live with that I thought that there is no strict need to
  >> limit the option this way from the very beginning.
  >>
  > As far as backward compatibility, isn't it better to lift that restriction
  > later rather than add it? I think the latter would very likely "break"
  > things whereas the former would not.
  >
  > I also prefer that restriction because it establishes a bound on how
  > frequently the symlink can change. Keeping it a one-shot deal makes the
  > values that show up in tools like top more reliable for admins.
]

I guess maybe it's time to drop one-shot requirement and as result
we can drop MMF_EXE_FILE_CHANGED bit completely, making overall code
simplier?

Our tool can live with any behaviour (and one shot and multishot,
doesn't matter).

	Cyrill
