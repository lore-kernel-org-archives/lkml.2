Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1FTPda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:33:30 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:40969 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752956Ab1FTPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:33:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 20gQWUgVM1nJWhQlTsy7i3RjUODu63AwNLuYVX9zi3ebjvC
 Mn0HXaa_81IMN2a8PC9EzfoGRTwe0TCNLVwq9yH1sTabM5P5WENp60.S..Qp
 j2JEG0t2UXlhtRmm4U_UfdPTCXJtpfiP6Du1OGB9c5uNuewi.WJpUs1eQKoz
 SSo7ck0Qgf.47OpiPAd6c2n38eOKWrURmMBfzSuX8JInPf8ui7Y0KSS_Egy0
 IOWSvxiBDwFGT_2Wn_aXAsSuJYIm8WZKYoa13M7hMXNYxSbCMuQWxkKIqqAL
 4EcrDo40it.kzsHHOKljcCGyHjwW2HsM2bkQ6Lr1TQm2JyYFI
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110620153244.214038140@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 20 Jun 2011 10:32:44 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: tj@kernel.org
Cc: Metathronius Galabant <m.galabant@googlemail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Adrian Drzewiecki <z@drze.net>
Cc: linux-kernel@vger.kernel.org
Subject: [slub p2 0/4] SLUB: [RFC] Per cpu partial lists V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset applied on top of the lockless patchset V7. It
introduces per cpu partial lists which allow a performance increase of
around ~15 during contention for the nodelock (can be tested using
hackbench).

These lists help to avoid per nodelocking overhead. Allocator latency
could be further reduced by making these operations work without
disabling interrupts (like the fastpath and the free slowpath) as well as
implementing better ways of handling ther cpu array with partial pages.

I am still not satisfied with the cleanliness of the code after these
changes. Some review with suggestions as to how to restructure the
code given these changes in operations would be appreciated.

It is interesting to note that BSD has gone to a scheme with partial
pages only per cpu (source: Adrian). Transfer of cpu ownerships is
done using IPIs. Probably too much overhead for our taste. The use
of a few per cpu partial pages looks to be beneficial though.

Note that there is no performance gain when there is no contention.

Performance:

				Before		After
./hackbench 100 process 200000
				Time: 2299.072	1742.454
./hackbench 100 process 20000
				Time: 224.654	182.393
./hackbench 100 process 20000
				Time: 227.126	182.780
./hackbench 100 process 20000
				Time: 219.608	182.899
./hackbench 10 process 20000
				Time: 21.769	18.756
./hackbench 10 process 20000
				Time: 21.657	18.938
./hackbench 10 process 20000
				Time: 23.193	19.537
./hackbench 1 process 20000
				Time: 2.337	2.263
./hackbench 1 process 20000
				Time: 2.223	2.271
./hackbench 1 process 20000
				Time: 2.269	2.301


