Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1C1TtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:49:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:47540 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1C1TtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:49:00 -0400
Date: Mon, 28 Mar 2011 21:48:57 +0200
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, "Alex,Shi" <alex.shi@intel.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        "Li, Shaohua" <shaohua.li@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
Message-ID: <20110328194857.GB7184@quack.suse.cz>
References: <20110302094246.GA7496@quack.suse.cz>
 <x491v2p4i0u.fsf@segfault.boston.devel.redhat.com>
 <20110302211748.GF7496@quack.suse.cz>
 <x49lj0x0zve.fsf@segfault.boston.devel.redhat.com>
 <20110304153248.GC2649@quack.suse.cz>
 <x49d3m6j35j.fsf@segfault.boston.devel.redhat.com>
 <x491v2mivv6.fsf@segfault.boston.devel.redhat.com>
 <1300779499.30136.353.camel@debian>
 <20110322161405.GB19716@quack.suse.cz>
 <x49r59zrqu9.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49r59zrqu9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-03-11 13:46:06, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > Jeff, I suppose the log files of fs_mark processes are on the same
> > device as the test directory, aren't they - that might explain the
> > flusher thread doing IO? The patch below
> 
> No.  My test environments are sane.  The file system is on a completely
> separate disk and it is unmounted and remounted in between each run.
> That should take care of any lost flushes.
  OK, I understand but let me clear out one thing. What fs_mark seems to be
doing is:
for given number of iterations { (-L option, default 1)
  fork each thread {
    start timer
    for i = 1 .. 10000 { (could be changed by option -n)
      write file i
    }
    stop timer
    for i = 1 .. 10000 {
      unlink file i
    }
    write statistics to log file
    exit
  }
  read all log files, write combined results to another log file
}

I see from blktrace data that indeed you are running more than one
iteration of the fs_mark process so the problem I was wondering about is
whether unlinking or writing of log files cannot interefere with the IO
happening while the timer is running.

Now log files are rather small so I don't really think they cause any
problem but they could be the data flusher thread writes - they are stored
in the current directory (unless you use -l option). So I my question was
aiming at where these files are stored - do you specify -l option and if
not, what is the current directory of fs_mark process in your setup?

I think unlinks could possibly cause problems and that's why I suggested we
add sync() to the parent process before it runs the next iteration...

> Did you receive my last couple of private emails commenting on the trace
> data?
  Yes, I did get them. I'll reply to them in a while.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
