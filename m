Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0KCPU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:20:56 -0400
Received: from ist.d-labs.de ([213.239.218.44]:58052 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab0KCPUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:20:55 -0400
Date: Wed, 3 Nov 2010 16:20:42 +0100
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: Andy Whitcroft <apw@canonical.com>, Audun Hoem <audun.hoem@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch.pl: fix CAST detection to not screw with
 parens handling
Message-ID: <20101103162042.297958c3@schatten.dmk.lab>
In-Reply-To: <1288785873-16519-1-git-send-email-florian@mickler.org>
References: <AANLkTimA1d88FwGGE-BW4WvyuaFB7xewN_ubko+kj2+X@mail.gmail.com>
	<1288785873-16519-1-git-send-email-florian@mickler.org>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Nov 2010 13:04:33 +0100
Florian Mickler <florian@mickler.org> wrote:

> Casts have to be handled after the last type that is followed by an
> opening parenthesis is handled.

That is the wrong fix. I realized now that with that patch we would
not claim anything as a CAST anymore. Better is probably to only claim
a CAST if av_pending is not set. Andy, would that work? It seems to be
alright... Do you have some tests for checkpatch?

Testing it with the reported line and some other random samples it
seems to be alright.

Regards,
Flo

>8------------------------------------------------------------------------
commit 11ed611c647420ea27124faf269d724b4fd3ade4
Author: Florian Mickler <florian@mickler.org>
Date:   Wed Nov 3 15:54:26 2010 +0100

    checkpatch.pl: fix CAST detection
    
    We should only claim that something is a cast if we did not encouter a
    token before, that did set av_pending.
    
    This fixes the operator * in the line below  to be detected as
    binary (vs unary).
    
     kmalloc(sizeof(struct alphatrack_ocmd) * true_size, GFP_KERNEL);
    
    Reported-by: Audun Hoem <audun.hoem@gmail.com>
    Signed-off-by: Florian Mickler <florian@mickler.org>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 90b54d4..06f5c44 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -859,7 +859,7 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
-		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/) {
+		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/ && $av_pending eq '_') {
 			print "CAST($1)\n" if ($dbg_values > 1);
 			push(@av_paren_type, $type);
 			$type = 'C';
