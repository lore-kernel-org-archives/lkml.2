Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864Ab2C3NRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:17:15 -0400
Received: from mailhost.anl.gov ([130.202.113.50]:49032 "EHLO mailhost.anl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760710Ab2C3NRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:17:05 -0400
Subject: Re: Is prctl(PR_SET_CHILD_SUBREAPER) going to break my code which checks getppid == 1?
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Karl Pickett <kjp@ci.uchicago.edu>
In-Reply-To: <20120330124426.GA13811@redhat.com>
Date: Fri, 30 Mar 2012 08:17:02 -0500
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        Lennart Poettering <lennart@poettering.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <376EB22C-893C-4AF8-81DC-3A7687B1AE1B@ci.uchicago.edu>
References: <46799FA3-D575-4A2D-8DEB-CE5149A4110D@ci.uchicago.edu> <20120330124426.GA13811@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 30, 2012, at 7:44 AM, Oleg Nesterov wrote:

> On 03/29, Karl Pickett wrote:
>> 
>> Re: http://thread.gmane.org/gmane.linux.kernel/1236479
>> 
>> I'm wondering if this is going to break code that checks getppid() == 1?
>> 
>> I have a TCL/TK GUI app that spawns ssh.  I want the ssh to die
>> immediately if the GUI process crashes, so ssh is launched with a wrapper
>> c program that does:
>> 
>>   prctl(PR_SET_PDEATHSIG, SIGHUP);
>>   if (getppid() == 1) /* parent died already? */
>>       return 0;
> 
> Yes, this won't work if the parent of this app does PR_SET_CHILD_SUBREAPER.
> 
>> So what is getppid() going to return for some user using this new
>> 'session manager reaper'?
> 
> The new parent's pid ;)
> 
> Perhaps you can do something like
> 
> 	ppid_for_child = getpid();
> 
> 	if (!fork()) {
> 		// Child
> 		prctl(PR_SET_PDEATHSIG);
> 		if (getppid() != ppid_for_child)
> 			return;
> 		...
> 	}

There are two problems with that.  1., I don't think TCL/TK lets me access the parent pre-fork env like that - all I can change is the execed code.  2., That has a clear race with pid wrap around.  You really need a prctl(PR_DID_MY_REAL_PARENT_DIE) function to be safe.


> 
> Just in case, I do not know how PR_SET_CHILD_SUBREAPER will be really used.
> I do not know if systemd will run the "normal" user applications under
> PR_SET_CHILD_SUBREAPER. Probably yes, but this is the question to Kay.
> 
> Oleg.
> 

