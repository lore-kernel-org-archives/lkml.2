Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2K2QQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:16:52 -0500
Received: from cha92-13-88-165-248-19.fbx.proxad.net ([88.165.248.19]:36963
	"EHLO jigen.glandium.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753852Ab2K2QQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:16:51 -0500
X-Greylist: delayed 1059 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2012 11:16:51 EST
Date: Thu, 29 Nov 2012 16:58:51 +0100
From: Mike Hommey <mh@glandium.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, NeilBrown <neilb@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Volatile Ranges (v7) & Lots of words
Message-ID: <20121129155851.GA24630@glandium.org>
References: <1348888593-23047-1-git-send-email-john.stultz@linaro.org>
 <20121002173928.2062004e@notabene.brown>
 <506B6CE0.1060800@linaro.org>
 <CAHO5Pa0KvH+MTYm6BCM5LHj995HpO+t87szyJjjXgupVq2VTfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa0KvH+MTYm6BCM5LHj995HpO+t87szyJjjXgupVq2VTfA@mail.gmail.com>
X-GPG-Fingerprint: 182E 161D 1130 B9FC CD7D  B167 E42A A04F A6AA 8C72
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 09:59:07PM +0100, Michael Kerrisk wrote:
> John,
> 
> A question at on one point:
> 
> On Wed, Oct 3, 2012 at 12:38 AM, John Stultz <john.stultz@linaro.org> wrote:
> > On 10/02/2012 12:39 AM, NeilBrown wrote:
> [...]
> >>   The SIGBUS interface could have some merit if it really reduces
> >> overhead.  I
> >>   worry about app bugs that could result from the non-deterministic
> >>   behaviour.   A range could get unmapped while it is in use and testing
> >> for
> >>   the case of "get a SIGBUS half way though accessing something" would not
> >>   be straight forward (SIGBUS on first step of access should be easy).
> >>   I guess that is up to the app writer, but I have never liked anything
> >> about
> >>   the signal interface and encouraging further use doesn't feel wise.
> >
> > Initially I didn't like the idea, but have warmed considerably to it. Mainly
> > due to the concern that the constant unmark/access/mark pattern would be too
> > much overhead, and having a lazy method will be much nicer for performance.
> > But yes, at the cost of additional complexity of handling the signal,
> > marking the faulted address range as non-volatile, restoring the data and
> > continuing.
> 
> At a finer level of detail, how do you see this as happening in the
> application. I mean: in the general case, repopulating the purged
> volatile page would have to be done outside the signal handler (I
> think, because async-signal-safety considerations would preclude too
> much compdex stuff going on inside the handler). That implies
> longjumping out of the handler, repopulating the pages with data, and
> then restarting whatever work was being done when the SIGBUS was
> generated.

There are different strategies that can be used to repopulate the pages,
within or outside the signal handler, and I'd say it's not that
important of a detail.

That being said, if the kernel could be helpful and avoid people
shooting themselves in the foot, that would be great, too.

I don't know how possible this would be but being able to get the
notification on a signalfd in a dedicated thread would certainly improve
things (I guess other usecases of SIGSEGV/SIGBUG handlers could
appreciate something like this). The kernel would pause the faulting
thread while sending the notification on the signalfd, and the notified
thread would be allowed to resume the faulting thread when it's done
doing its job.

Mike
