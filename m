Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2FUP4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:56:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29036 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab2FUP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:56:46 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XOt6boVe9ZQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=qi6N67ELxb11JToVk7kA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340294204.27036.183.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com
Date: Thu, 21 Jun 2012 11:56:44 -0400
In-Reply-To: <1340293617.27036.177.camel@gandalf.stny.rr.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
	 <1340060577-9112-1-git-send-email-dhsharp@google.com>
	 <1340293617.27036.177.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 11:46 -0400, Steven Rostedt wrote:

> I'm wondering if it would be better to just not do the swap, and return
> NULL when it is empty. This would also fix the problem, as the
> read_stamp will only be set when you actually have data.

Does something like this work for you. Note, this is totally untested!

-- Steve

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ad0239b..5943044 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3246,6 +3246,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	if (cpu_buffer->commit_page == cpu_buffer->reader_page)
 		goto out;
 
+	/* Don't bother swapping if the ring buffer is empty */
+	if (rb_num_of_entries(cpu_buffer) == 0)
+		goto out;
+
 	/*
 	 * Reset the reader page to size zero.
 	 */


