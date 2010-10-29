Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964Ab0J2Owg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:52:36 -0400
Received: from thunk.org ([69.25.196.29]:48785 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933926Ab0J2Owb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:52:31 -0400
Date: Fri, 29 Oct 2010 10:52:12 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101029145212.GA21205@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Pekka Enberg <penberg@kernel.org>,
	Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>,
	Arjan van de Ven <arjan@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com>
 <AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
 <AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
 <AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
 <AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
 <20101028090002.GA12446@elte.hu>
 <AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
 <20101028133036.GA30565@elte.hu>
 <20101028170132.GY27796@think>
 <AANLkTikgO=n88ZAQ6EYAg1+aC1d0+o923FYyhkOouaH5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikgO=n88ZAQ6EYAg1+aC1d0+o923FYyhkOouaH5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 08:57:49PM +0300, Pekka Enberg wrote:
> Don't we need to call ext4_should_writeback_data() before we drop the
> lock? It pokes at ->i_mode which needs ->i_mutex AFAICT.

No, it should be fine.  It's not like a file is going to change from
being a regular file to a directory or vice versa.  :-)

>From a quick inspection it looks OK, but I haven't had the time to
look more closely to be 100% sure, and of course I haven't run it
through a battery of regression tests.  For normal usage it should be
fine though.

Aidar, if you'd be willing to try it with this patch applied, and with
the file system mounted data=writeback, and then let me know what the
latencytop reports, that would be useful.  I'm fairly sure that fixing
llseek() probably won't make that much difference, since it will
probably spread things out to other places, but it would be good to
make the experiment.

We will probably also need to use the uninitialized bit for protecting
data from showing up after a crash for extent-based files, and turning
on data=writeback is a good way to simulate that.  (Sorry, no way
we're going to make a change like that this merge cycle, but that
might be something we could do for 2.6.38.)  But I am curious to see
what are the next things that come up as being problematic after that.

Thanks,

					- Ted
