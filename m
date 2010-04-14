Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0DNRi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 13:38:28 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:57629 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab0DNRi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 13:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=subject
	:from:to:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=drama; b=UyHfO
	YfX61lrF4/lPUibf3PP+mWMbdvtrx43SZQZaENYx5nHGarLtckNHMLuOyec38TV7
	io+JiGYTVpRz9xtLjMYlQTrRdpbmwAvq9fIp4qKp9gQHP+hV6Bx0QGW7+1sMyAGN
	XKYxJ9d4HbSYcYqU/KdqXmIgG7A3Ahtfv/9g8U=
Subject: Re: [PATCH 5/6] ceph: refactor mount related functions, add helpers
From: yehuda <yehuda@hq.newdream.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       sage@newdream.net, axboe@kernel.dk
In-Reply-To: <87bpdm9x0e.fsf@basil.nowhere.org>
References: <1271201355-9346-1-git-send-email-yehuda@hq.newdream.net>
	 <b29a49e98a5186f83094b7a7a5dbc74647921e10.1271198630.git.yehuda@hq.newdream.net>
	 <87bpdm9x0e.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Wed, 14 Apr 2010 10:39:23 -0700
Message-Id: <1271266763.7701.20.camel@yehudasa-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 11:57 +0200, Andi Kleen wrote:
> Yehuda Sadeh <yehuda@hq.newdream.net> writes:
> >  
> > +int ceph_copy_to_page_vector(struct page **pages,
> > +				    const char *data,
> > +				    loff_t off, size_t len)
> > +{
> > +	int i = 0;
> > +	int po = off & ~PAGE_CACHE_MASK;
> > +	int left = len;
> > +	int l;
> > +
> > +	while (left > 0) {
> > +		l = min_t(int, PAGE_CACHE_SIZE-po, left);
> 
> int seems like exactly the wrong type here.

Ah yes.. there are other places around there that need fixing too.
Changing to size_t:

@@ -362,6 +362,52 @@ static int copy_user_to_page_vector(struct page
**pages,
 	return len;
 }
 
+int ceph_copy_to_page_vector(struct page **pages,
+				    const char *data,
+				    loff_t off, size_t len)
+{
+	int i = 0;
+	size_t po = off & ~PAGE_CACHE_MASK;
+	size_t left = len;
+	size_t l;
+
+	while (left > 0) {
+		l = min_t(size_t, PAGE_CACHE_SIZE-po, left);
+		memcpy(page_address(pages[i]) + po, data, l);
+		data += l;
+		left -= l;
+		po += l;
+		if (po == PAGE_CACHE_SIZE) {
+			po = 0;
+			i++;
+		}
+	}
+	return len;
+}
+
+int ceph_copy_from_page_vector(struct page **pages,
+				    char *data,
+				    loff_t off, size_t len)
+{
+	int i = 0;
+	size_t po = off & ~PAGE_CACHE_MASK;
+	size_t left = len;
+	size_t l;
+
+	while (left > 0) {
+		l = min_t(size_t, PAGE_CACHE_SIZE-po, left);
+		memcpy(data, page_address(pages[i]) + po, l);
+		data += l;
+		left -= l;
+		po += l;
+		if (po == PAGE_CACHE_SIZE) {
+			po = 0;
+			i++;
+		}
+	}
+	return len;
+}
+
 /*
  * copy user data from a page vector into a user pointer
  */

Thanks,
Yehuda

