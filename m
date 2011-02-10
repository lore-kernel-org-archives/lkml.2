Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1BJCpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:45:31 -0500
Received: from smtp-out.google.com ([74.125.121.67]:55987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1BJCpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:45:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YRyG1G8nzXhyuSea8LwMOytCINIW8KR0ga9Diks1n91pJNC6SMby9OeHHlKw7bamgX
         tJBzYuHQZRSgG+7MEWbQ==
MIME-Version: 1.0
In-Reply-To: <20110210020946.GA27040@redhat.com>
References: <20110210013211.21573.69260.stgit@neat.mtv.corp.google.com>
	<20110210020946.GA27040@redhat.com>
Date: Wed, 9 Feb 2011 18:45:25 -0800
Message-ID: <AANLkTi=dZDK6VosLX8JH4gJyRQ0KXGKMA5vhJ-7D93s7@mail.gmail.com>
Subject: Re: [PATCH] Avoid preferential treatment of groups that aren't backlogged
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 6:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> In upstream code once a group gets backlogged we put it at the end
> and not at the beginning of the tree. (I am wondering are you looking
> at the google internal code :-))
>
> So I don't think that issue of a low weight group getting more disk
> time than its fair share is present in upstream kernels.

You've caught me re-using a commit description.  :)

Here's an example of the kind of tests that fail without this patch
(run via the test that Justin and Akshay have posted):

15:35:35 INFO ----- Running experiment 14: 950 rdrand, 50 rdrand.delay10
15:35:55 INFO Experiment completed in 20.4 seconds
15:35:55 INFO experiment 14 achieved DTFs: 886, 113
15:35:55 INFO experiment 14 FAILED: max observed error is 64, allowed is 50

15:35:55 INFO ----- Running experiment 15: 950 rdrand, 50 rdrand.delay50
15:36:16 INFO Experiment completed in 20.5 seconds
15:36:16 INFO experiment 15 achieved DTFs: 891, 108
15:36:16 INFO experiment 15 FAILED: max observed error is 59, allowed is 50

Since this is Jens' unmodified tree, I've had to change
BLKIO_WEIGHT_MIN to 10 to allow this test to proceed.  We typically
run many jobs with small weights, and achieve the requested isolation:
see below results with this patch:

14:59:17 INFO ----- Running experiment 14: 950 rdrand, 50 rdrand.delay10
14:59:36 INFO Experiment completed in 19.0 seconds
14:59:36 INFO experiment 14 achieved DTFs: 947, 52
14:59:36 INFO experiment 14 PASSED: max observed error is 3, allowed is 50

14:59:36 INFO ----- Running experiment 15: 950 rdrand, 50 rdrand.delay50
14:59:55 INFO Experiment completed in 18.5 seconds
14:59:55 INFO experiment 15 achieved DTFs: 944, 55
14:59:55 INFO experiment 15 PASSED: max observed error is 6, allowed is 50

As you can see, it's with seeky workloads that come and go from the
service tree where this patch is required.

Chad
