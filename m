Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2IUAjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:39:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37639 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab2IUAjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:39:46 -0400
Date: Thu, 20 Sep 2012 17:37:06 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH] pstore: avoid recursive spinlocks in the
 oops_in_progress case
Message-ID: <20120921003706.GB14399@lizard>
References: <1347903824.29767.15.camel@cliu38-desktop-build>
 <20120920225727.GD29721@lizard>
 <3908561D78D1C84285E8C5FCA982C28F19D43812@ORSMSX108.amr.corp.intel.com>
 <20120920232536.GB8209@lizard>
 <3908561D78D1C84285E8C5FCA982C28F19D43892@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D43892@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 11:48:32PM +0000, Luck, Tony wrote:
> > True, but the lock is used to protect pstore->buf, I doubt that
> > any backend will actually want to grab it, no?
> 
> The lock is doing double duty to protect the buffer, and the back-end driver.
> 
> But even if we split it into two (one for the buffer, taken by pstore, and one
> internal to the backend to protect interaction with the f/w). Ifwe ignore the
> fact that we can't get the lock that protects  the buffer means it is very likely
> that we corrupt the previous record that was being written by clobbering the
> buffer with the data for this new record.
> 
> I'd prefer to maximize the chances that the earlier record gets written.

Sure, I applied the original patch.

Btw, do you expect that backends protect themselves from concurrent
->write calls, or pstore guarantees to protect backends?

Because the latter is not always possible, for example in tracing: we
won't able to grab locks at all (but not all backends can do tracing
anyway -- they must do things atomically).

Plus, sometimes having the global lock is not "efficient", backends
know better: they might have separate locks per message type.

And my plan was to get rid of the fact that backends touch pstore->buf
directly. Backends would always receive anonymous 'buf' pointer (we
already have write_buf callback that does exactly this), and thus it
would be backends' worry to protect against concurrency. In this
scheme, pstore's console code won't need to grab locks at all: we'll
just pass console string to the backend directly.

And backends, if they can't do writes atomically, will grab their
own locks.

Thanks,
Anton.
