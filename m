Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab2IYUeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:34:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29025 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab2IYUeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:34:02 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9u18f0FHYrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=1rWL9HH1EmwA:10 a=90eQS3kOLqgINKrmiYoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348605237.22822.19.camel@gandalf.local.home>
Subject: Re: ktest.pl always returns 0?
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 25 Sep 2012 16:33:57 -0400
In-Reply-To: <20120925194019.GA25626@kroah.com>
References: <20120925180028.GA22896@kroah.com>
	 <1348596917.6786.12.camel@fedora> <20120925194019.GA25626@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 12:40 -0700, Greg KH wrote:

> Hey, it's not my fault your employer has a crummy email system that
> can't handle remote access well, I just went off of the Author: line in
> your ktest.pl kernel commits :)

Yeah, I'm not upset by it. I just want to warn people that there's times
I may spend long periods of not answering that email.

> 
> > > I'm trying to use ktest to do build tests of the stable patch series to
> > > verify I didn't mess anything up, but I'm finding that ktest always
> > > returns 0 when finished, no matter if the build test was successful or
> > > failed.
> > 
> > Hmm, I should fix that. Yeah, I agree, if it fails a test it should
> > return something other than zero. But I think that only happens if you
> > have DIE_ON_FAILURE = 0. As IIRC, the perl "die" command should exit the
> > application with an error code.
> > 
> > But yeah, I agree, if one of the tests fail, the error code should not
> > be zero. I'll write up a patch to fix that. Or at least add an option to
> > make that happen.
> 
> That would be great.
> 
> > > Is this right?  Is there some other way to determine if ktest fails
> > > other than greping the output log?
> > 
> > If you have DIE_ON_FAILURE = 1 (default) it should exit with non zero.
> 
> It doesn't do that, test it and see (this is with what is in Linus's
> 3.6-rc7 tree, I didn't test linux-next if that is newer, my apologies.)

This should have been something from day one. I'll go ahead and try it
out. According to the perl-doc man pages the "die" command has:

           If an uncaught exception results in interpreter exit, the exit
           code is determined from the values of $! and $? with this
           pseudocode:

               exit $! if $!;              # errno
               exit $? >> 8 if $? >> 8;    # child exit status
               exit 255;                   # last resort

I'll investigate this further.

> 
> > > Oh, and any hints on kicking off a ktest process on a remote machine in
> > > a "simple" way?  I'm just using ssh to copy over a script that runs
> > > there, wrapping ktest.pl up with other stuff, I didn't miss the fact
> > > that ktest itself can run remotely already, did I?
> > 
> > I'm a little confused by this question. Do you want a server ktest? That
> > is, have a ktest daemon that listens for clients that sends it config
> > files and then runs them? That would actually be a fun project ;-)
> > 
> > You're not running ktest on the target machine are you? The way I use it
> > is the following:
> > 
> > I have a server that I ssh to and run ktest from. It does all the builds
> > there on the server and this server has a means to monitor some target.
> > I use ttywatch that connects to the serial of the target, in which ktest
> > uses to read from.
> > 
> > Sometimes this "server" is the machine I'm logged in to.  And I just run
> > ktest directly.
> > 
> > Can you explain more of what you are looking for?
> 
> I want to be able to say:
> 	- take this set of stable patches and go run a 'make
> 	  allmodconfig' build on a remote machine and email me back the
> 	  answer because I might not be able to keep an internet
> 	  connection open for the next 5-15 minutes it might take to
> 	  complete that task.

I cheat and run all my ktests in screen sessions ;-)

> 
> I don't do boot tests with these kernel build tests, although sometime
> in the future it would be nice to do that.  Right now I do that testing
> manually, as it's pretty infrequent (once per release usually.)
> 
> So yes, a 'ktest' server would be nice.  I've attached the (horrible)
> script below that I'm using for this so far.  It seems to work well, and
> I can do builds on a "cloud" server as well as my local build server
> just fine, only thing needed to do is change the user and machine name
> in the script.

This looks like my next "when I have time" project ;-).


> 
> I know ktest doesn't handle quilt patches yet, which is why I apply them
> "by hand" now to a given git tree branch, if you ever do add that
> option, I'll gladly test it out and change my script to use whatever
> format it needs.
> 

Yeah, I need to make ktest work with quilt, as I'm still a fan.

But currently the ones that pay me actually are giving me things to do.
Something about satisfying customers or some other crap. Thus, my "down
time" is limited at the moment :-(  But when things on the customer side
slows down again, I'll definitely work on these changes.

Thanks for the ideas! I'm actually looking forward to working on this.
But in the mean time, I will test the next time ktest fails on me to see
what the result of $? is.

-- Steve


