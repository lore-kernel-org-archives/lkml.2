Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1GHURh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 16:17:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab1GHURg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 16:17:36 -0400
Date: Fri, 8 Jul 2011 16:17:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: tony.luck@intel.com
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org
Subject: pstore dump inside an nmi handler
Message-ID: <20110708201731.GA3025@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

I was playing with the APEI EINJ module, injecting errors trying to
capture a GHES record, then panic into a kdump kernel and reboot.

Matthew brought to my attention that pstore should capture an error record
on the panic path using kmsg_dump().  After injecting an error with EINJ,
I went to check to see if there was a pstore entry.  There wasn't.

Playing on another box, I noticed the machine double faulted and didn't
even make it into a kdump kernel.

Upon investigation, I noticed that when a fatal error occurs on the
platform, it will generate an NMI that will be handle by the
ghes_nmi_handler.  This handler calls panic() which calls kmsg_dump()
which calls pstore_dump().

Inside pstore_dump(), the first thing it tries to grab is a mutex_lock()
(inside an nmi hander).  This seems to be the root cause of my problems.

I am not familiar enough with pstore to just modify its locking, so I
wanted to ask you.

My first thought was to wrap the mutex_lock with a 'if !in_nmi()', but that
seemed kinda hacky.  Then I was wondering if there was a way to do this
locklessly or atomically because you are only dealing with whole blocks I
think.  I don't know.

Wanted to give you a heads up and seek your thoughts.  I am willing to
hack up some code and test. :-)

Cheers,
Don

