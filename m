Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab2B1N3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:29:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:49834 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2B1N3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:29:49 -0500
Message-ID: <1330435782.11248.89.camel@twins>
Subject: Re: lockdep: Warning & NULL ptr deref
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 28 Feb 2012 14:29:42 +0100
In-Reply-To: <1330442692.3719.7.camel@lappy>
References: <1330442692.3719.7.camel@lappy>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 10:24 -0500, Sasha Levin wrote:
> 
> I'll send some patches to prevent the NULL deref itself which happens
> since a chunk of the code in lockdep.c assumed hlock_class() can't
> return NULL.
> 
There's tons of code actually assuming that..

> This won't fix the actual problem though, I'm not sure exactly how a
> held lock wouldn't have a class initialized to it. 

static inline struct lock_class *hlock_class(struct held_lock *hlock)                        
{               
        if (!hlock->class_idx) {                                                             
                /*
                 * Someone passed in garbage, we give up.                                    
                 */                                                                          
                DEBUG_LOCKS_WARN_ON(1);                                                      
                return NULL;
        }
        return lock_classes + hlock->class_idx - 1; 
}

Typically that translates to severe memory corruption.
