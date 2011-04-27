Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1D0Jb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:31:27 -0400
Received: from service87.mimecast.com ([94.185.240.25]:41238 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755563Ab1D0JbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:31:25 -0400
Subject: Re: [PATCH] kmemleak: Never return a pointer you didn't 'get'
From: Catalin Marinas <catalin.marinas@arm.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303385972-2518-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1303385972-2518-1-git-send-email-ext-phil.2.carmody@nokia.com>
Organization: ARM Limited
Date: Wed, 27 Apr 2011 10:31:20 +0100
Message-ID: <1303896680.15101.1.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 27 Apr 2011 09:31:20.0862 (UTC) FILETIME=[DE1C2BE0:01CC04BD]
X-MC-Unique: 111042710312203501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 12:39 +0100, Phil Carmody wrote:
> Old - If you don't get the last pointer that you looked at, then it will
> still be put, as there's no way of knowing you didn't get it.
> 
> New - If you didn't get it, then it refers to something deleted, and
> your work is done, so return NULL.
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Good catch. But I think the code may look slightly simpler as below:

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index c1d5867..aacee45 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1414,9 +1414,12 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	++(*pos);
 
 	list_for_each_continue_rcu(n, &object_list) {
-		next_obj = list_entry(n, struct kmemleak_object, object_list);
-		if (get_object(next_obj))
+		struct kmemleak_object *obj =
+			list_entry(n, struct kmemleak_object, object_list);
+		if (get_object(obj)) {
+			next_obj = obj;
 			break;
+		}
 	}
 
 	put_object(prev_obj);


Thanks.

-- 
Catalin


