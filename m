Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab2AMQ36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 11:29:58 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:10741 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2AMQ3z convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Fri, 13 Jan 2012 11:29:55 -0500
Message-Id: <4F106A4A020000780006C90E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 13 Jan 2012 16:30:50 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <npiggin@kernel.dk>
Cc: <linux-kernel@vger.kernel.org>
Subject: ticket spin locks vs. interrupt re-enabling during spin loops
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

prior to your introduction of ticket locks on x86 interrupts would get
re-enabled in what was then called __raw_spin_lock_flags(). While I
realize that this is tricky with ticket locks, have you ever thought
through what it would take to implement this correctly?

We had this working well in our Xen kernels up to 2.6.39, but the
changes to try_to_wake_up() in 3.0 uncovered a problem with the
original implementation, and so I'm now struggling with finding a
solution that can cover both this problem as well as to another
possible scenario I meanwhile thought of that would break with
the original code (an open coded spinning loop over spin_trylock()
continuing until success in a scenario similar to that in the new
try_to_wake_up()). A draft implementation that I had put
together today isn't working quite right yet (and hence I can't
quantify its performance impact at all).

One fundamental question of course is whether this really is worth
it at all, since re-enabling interrupts here inherently implies that
tickets may need to be dropped, and hence the fairness they are
intended to guarantee is being undermined. But keeping interrupts
frequently disabled for virtually indefinite periods of time (as can
happen in a CPU over-committed virtualized environment) is
certainly a problem that's worth considering solutions for.

Jan

