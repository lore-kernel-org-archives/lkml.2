Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836Ab0GUIa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 04:30:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62687 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762814Ab0GUIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 04:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bxNUmtnCgp0SLf/U6qDzSi8NVK/e1n9AK8yO+uqBpUug5Ie/spHmoPJ4tkhC3skDyB
         lah/uw6HX9Lh+cZmtRty6ynPhXazFmgWD3l52K2AeEIS2RxLTyUMa/DcgRcK166d66ap
         osDjh+FoupJhqLZhSRnA/JiWJdrmum06wYWzU=
Date: Wed, 21 Jul 2010 01:30:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100721083048.GA21558@core.coreip.homeip.net>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
 <20100524161527.GC3182@core.coreip.homeip.net>
 <20100616083903.GU17833@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616083903.GU17833@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 10:39:03AM +0200, Daniel Mack wrote:
> Hi Dmitry,
> 
> On Mon, May 24, 2010 at 09:15:28AM -0700, Dmitry Torokhov wrote:
> > On Mon, May 24, 2010 at 06:08:05PM +0200, Daniel Mack wrote:
> > > any feelings about this approach?
> > > 
> > 
> > Still pondering...I applied the very first patch though...
> 
> Any news about this? I have no problem throwing away the whole patch set
> and use a different approach, if there is any :)
> 

Daniel,

The approach is pretty solid, with the exception that I do not think
we'd save much if we allocate every axis data separately (as I mentioned
in one of my earlier mails).

Coudl you please take a look at the following patches and let me know if
you see something wrong.

Thanks!

-- 
Dmitry


Input: add static inline accessors for ABS properties

From: Daniel Mack <daniel@caiaq.de>

In preparation for dynamically allocated ABS axis, introduce a number of
sttaic inline access helpers. This should make the transition less
painful.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 include/linux/input.h |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)


diff --git a/include/linux/input.h b/include/linux/input.h
index 339d043..4a55311 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1469,6 +1469,36 @@ static inline void input_set_abs_params(struct input_dev *dev, int axis, int min
 	dev->absbit[BIT_WORD(axis)] |= BIT_MASK(axis);
 }
 
+#define INPUT_GENERATE_ABS_ACCESSORS(_suffix, _item)			\
+static inline int input_abs_get_##_suffix(struct input_dev *dev,	\
+					  unsigned int axis)		\
+{									\
+	return dev->abs##_item[axis];					\
+}									\
+									\
+static inline void input_abs_set_##_suffix(struct input_dev *dev,	\
+					   unsigned int axis, int val)	\
+{									\
+	dev->abs##_item[axis] = val;					\
+}
+
+INPUT_GENERATE_ABS_ACCESSORS(min, min)
+INPUT_GENERATE_ABS_ACCESSORS(max, max)
+INPUT_GENERATE_ABS_ACCESSORS(fuzz, fuzz)
+INPUT_GENERATE_ABS_ACCESSORS(flat, flat)
+INPUT_GENERATE_ABS_ACCESSORS(res, res)
+
+static inline int input_abs_get_val(struct input_dev *dev, unsigned int axis)
+{
+	return dev->abs[axis];
+}
+
+static inline void input_abs_set_val(struct input_dev *dev,
+				     unsigned int axis, int val)
+{
+	dev->abs[axis] = val;
+}
+
 int input_get_keycode(struct input_dev *dev,
 		      unsigned int scancode, unsigned int *keycode);
 int input_set_keycode(struct input_dev *dev,
