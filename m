Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab1ALEHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 23:07:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932791Ab1ALEHE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 23:07:04 -0500
MIME-Version: 1.0
In-Reply-To: <1294804776.2821.4.camel@perseus>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
 <1294768668.2435.177.camel@doink> <1294804776.2821.4.camel@perseus>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 20:06:41 -0800
Message-ID: <AANLkTim8rQb3mDFHg7DmbTZa20FxRGk3wJCjOkz=JG9S@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
To: Ian Kent <raven@themaw.net>
Cc: aelder@sgi.com, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 7:59 PM, Ian Kent <raven@themaw.net> wrote:
>
> Isn't the parent i_mutex held during mkdir()?

Yes, but a lookup that hits in the dentry cache won't actually take
the parent mutex.

So as far as I can tell, doing the "d_add()" before setting d_op can
result in another CPU coming in and seeing the newly added dentry
before d_op has actually been initialized. Exactly because it will do
the dentry lookup without holding any mutex.

Of course, it's a very small window, so it probably doesn't matter in practice.

>> Looking at it quickly, I don't think that would matter for
>> the case at hand.  I.e., that might be safer but it doesn't
>> address the fact that these fields are getting initialized
>> multiple times.
>
> Yeah, a hangover from changes done over time.
> Not setting the dentry op in ->lookup() should fix this.

Alex, care to test just removing the d_set_d_op() call from autofs4_lookup()?

(That code is a bit scary, though - it explicitly makes it a negative
dentry with a d_instantiate(dentry, NULL), and then hides the inode
information away separately. Scary scary)

              Linus
