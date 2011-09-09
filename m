Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790Ab1IITYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 15:24:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39155 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534Ab1IITYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 15:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-oOHXEhnA+zpwA9GR7k1TX3Wn6XuOdc3TB4MPNiSpskiw@mail.gmail.com>
References: <cover.1314725877.git.jbaron@redhat.com> <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
 <20110908165230.a7505321.akpm@linux-foundation.org> <1315534396.11939.10.camel@Joe-Laptop>
 <20110908204200.6cf7abc2.akpm@linux-foundation.org> <1315540963.11939.12.camel@Joe-Laptop>
 <CAO+b5-oOHXEhnA+zpwA9GR7k1TX3Wn6XuOdc3TB4MPNiSpskiw@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 9 Sep 2011 13:23:43 -0600
Message-ID: <CAJfuBxx=r_P7em_naUN_c96A++V4v6nfd8B_V2dppRag-z_qwg@mail.gmail.com>
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct _ddebug
 descriptor definitions
To: Jason Baron <jbaron@redhat.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        gregkh@suse.de, Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 4:31 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Fri, Sep 9, 2011 at 6:02 AM, Joe Perches <joe@perches.com> wrote:
>> On Thu, 2011-09-08 at 20:42 -0700, Andrew Morton wrote:
>> > On Thu, 08 Sep 2011 19:13:16 -0700 Joe Perches <joe@perches.com> wrote:
>> > > On Thu, 2011-09-08 at 16:52 -0700, Andrew Morton wrote:
>> > > > On Tue, 30 Aug 2011 14:28:41 -0400
>> > > > Jason Baron <jbaron@redhat.com> wrote:
>> > > > > Replace the repetitive struct _ddebug descriptor definitions with
>> > > > > a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.
>> > > > > +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)              \
>> > > > > +       static struct _ddebug __used __aligned(8)               \
>> > > > > +       __attribute__((section("__verbose"))) name = {          \
>> > > > > +               .modname = KBUILD_MODNAME,                      \
>> > > > > +               .function = __func__,                           \
>> > > > > +               .filename = __FILE__,                           \
>> > > > > +               .format = (fmt),                                \
>> > > > > +               .lineno = __LINE__,                             \
>> > > > > +               .flags =  _DPRINTK_FLAGS_DEFAULT,               \
>> > > > > +               .enabled = false,                               \
>> > > > > +       }
>> > > > <anal>That macro implements a definition, not a declaration</anal>
>> > > Andrew, that's not quite true
>> > It's precisely true.
>> Not according to the c99 standard section 6.7
>
> Have you read that paragraph ? This is what I found in paragraph 6.7,
> which confirms Andrews interpretation:
>
> <quote>
> A declaration speciﬁes the interpretation and attributes of a set of
> identiﬁers. A deﬁnition of an identiﬁer is a declaration for that
> identiﬁer that:
> - for an object, causes storage to be reserved for that object;
> - for a function, includes the function body;
> - for an enumeration constant or typedef name, is the (only)
> declaration of the identiﬁer.
> </quote>
>
> Bart.
>


I hesitate to churn this more (I have patchset to go on top of all this) but

Id like to see an INIT_DYNAMIC_DEBUG_METADATA,
along with ability to expose the descriptor.

This would support pr_dbg_cont(), by letting it see/reuse
the same descriptor that controls the pr_debug that started
the multi-call message.  While this defeats the "atomicity"
of buffering the entire message before calling printk,
it does so only for the actual uses of KERN_CONT.

It also allows for "lite" usage of dynamic-debug,
including 1..few descriptor per file or module to control all debug printing.
As outlined, this "lite" usage is determined by the coder,
it would be cool if it were more configurable than that,
but I dont see how that would work atm.


Now that the worms have escaped the can, one other thought:
	unsigned int lineno:24;
allows for insanely large files.  The largest in the tree is 29k,
16 bits would cover all files likely to be accepted in the future.
Even allowing for never-to-be-submitted machine-generated code,
Id think 18 bits would suffice.  ~250k lines should be enough ;-)

Given that my patchset adds flags-filtering
( echo mt+p > $CONTROL )
The availability of user-flags, which do nothing but mark callsites,
has some value - user can mark arbitrary sets of callsites,
then enable/disable them as a group or subgroup:

echo function foo +x > $CONTROL
...
echo x+p > $CONTROL
echo y-p > $CONTROL
echo z+p > $CONTROL
echo yz-p > $CONTROL

Since since it works with module/file/function filtering, 3-4 user
flags should be plenty.
