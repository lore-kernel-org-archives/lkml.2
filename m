Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0L2U1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 15:27:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60895 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0L2U1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 15:27:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=rz3mp3RDC1dXwirYOPwsXCgUTOuT0kGiQVuElg+U6FigAZREMjwj3bNz5DPOonAgbt
         dEKrD/pKTH7zdApwzmtjUd39RjJS7j9Ak2RyPtLmutLZv7m4VG0lPhxB6Bi0wA2enXbX
         enFUeVYw+mZpoqVQ1XIAgaGLz+YjZ1e+gxlI4=
MIME-Version: 1.0
Date: Wed, 29 Dec 2010 15:27:38 -0500
Message-ID: <AANLkTi=jnHFThon6pApmozJ0dmu5Wimd46=t-NrmOWDW@mail.gmail.com>
Subject: Question about in_interrupt() semantics with regard to softirqs.
From: Justin Seyster <jrseys@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to understand the in_interrupt() function, and it seems
that it will return true for normal, non-interrupt code that disables
bottom half processing.  It looks like that behavior is intentional,
but I don't understand why it's designed that way.  I'm sorry if I'm
stating something obvious here; it would help me a lot if somebody
double checked my reasoning!

in_interrupt() checks a hardirq count and a softirq count, but I found
out that these two counts behave very differently.  The hardirq count
tracks the nesting depth of hardware interrupts (which is what I would
expect), but the softirq count behaves like the preempt count,
tracking whether softirqs are currently enabled.

So if normal code (executing on behalf of a user process) disables
softirqs with local_bh_disable(), it will get a true return value from
in_interrupt() until it finally reenables them.  But disabling
hardirqs will not have the same effect: the hardirq count is
unchanged, and in_interrupt() will still return false.

My question is: is there a design decision for this asymmetry between
hard and softirqs?  Also, is there a function that does what I really
wanted, which is to return true iff execution is actually in
bottom-half context?  Thanks!
        --Justin
