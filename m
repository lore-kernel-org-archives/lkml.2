Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2B2IU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:20:28 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:3962 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2B2IU0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Wed, 29 Feb 2012 03:20:26 -0500
Message-Id: <4F4DEDFF02000078000755AB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 29 Feb 2012 08:21:03 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] consolidate WARN_...ONCE() static variables
References: <4F4BAAFA0200007800074F8F@nat28.tlf.novell.com>
 <20120227160302.ef9f6af4.akpm@linux-foundation.org>
 <4F4C93520200007800075197@nat28.tlf.novell.com>
 <20120227234451.3a00a76a.akpm@linux-foundation.org>
 <4F4C983002000078000751AE@nat28.tlf.novell.com>
 <20120228001210.26b59479.akpm@linux-foundation.org>
 <4F4C9B7802000078000751BC@nat28.tlf.novell.com>
 <20120228003206.e661f926.akpm@linux-foundation.org>
 <4F4CA56202000078000751EF@nat28.tlf.novell.com>
 <20120228131936.b565bbcc.akpm@linux-foundation.org>
In-Reply-To: <20120228131936.b565bbcc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.12 at 22:19, Andrew Morton <akpm@linux-foundation.org> wrote:
> So the idea behind the patch is to use the "unlikely" as a sign that
> the data is rarely touched, so we can move it into its own section to
> prevent it from adding sparseness to data which is more frequently
> touched.
> 
> Correct?  If so, that's key: please copy-n-paste this into the
> changelog.

Done so for the next revision.

>> The space saving results from grouping (many) 1-byte entities
>> together, which (when emitted normally) will generally require
>> padding to 4 or 8 bytes (as being adjacent with other static data
>> in the same or next compilation unit). That padding won't occur
>> if all of the items in a given section are of the same size (and
>> alignment).
> 
> OK.  So the new section should only be used for static bool (or static
> char)?

That's a little too strong, but yes, the change would be less
efficient when objects with an alignment requirement of more than a
byte would get added to that same section.

Avoiding this is difficult though: gcc doesn't allow section name
templates (where e.g. the alignment could be embedded in the
section name by the compiler), nor does it allow any other means
to generate the section name on the fly in all possible cases (it
would only be possible when the object has function scope, as
there we could use an asm() for doing this). And requiring to
_literally_ (i.e. without any alignof() or sizeof()) specify the
respective number would be rather ugly (and calling for mistakes).
I can't think of other alternatives.

Jan

