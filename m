Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab1KHOcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:32:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab1KHOcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:32:51 -0500
Date: Tue, 8 Nov 2011 12:32:28 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git
	repository, tools/perf/ and tools/kvm/
Message-ID: <20111108143228.GC14272@ghostprotocols.net>
References: <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com> <20111107203255.GF24234@thunk.org> <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com> <4EB85969.2010108@codemonkey.ws> <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB9315A.10806@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 08, 2011 at 02:40:42PM +0100, Gerd Hoffmann escreveu:
> > Indeed, documentation is lacking, I think coming from a kernel
> > standpoint I relied too much in the "documentation is source code"
> > mantra of old days.
 
> Sorry for the shameless plug, but as you are speaking of lacking

Thank you! Its easier when I get the questions for specific problems in
the documentation :-)

> documentation:  Where the heck is the perf config file documented, other
> than source code?  Reading the parser to figure how the config file is
> supposed to look like really isn't fun :(
 
> I'm looking for a way to disable the colors in the perf report tui.  Or
> configure them into something readable.  No, light green on light gray
> which is used by default isn't readable.

That was fixed in 3.2-rc1, where also we have:

[acme@felicio linux]$ cat tools/perf/Documentation/perfconfig.example
[colors]

	# These were the old defaults
	top = red, lightgray
	medium = green, lightgray
	normal = black, lightgray
	selected = lightgray, magenta
	code = blue, lightgray

[tui]

	# Defaults if linked with libslang
	report = on
	annotate = on
	top = on

[buildid]

	# Default, disable using /dev/null
	dir = /root/.debug
[acme@felicio linux]$

So you can use:

[tui]

	report = off

To disable the TUI altogether or use:

$ perf report --stdio

Or tweak the colors to your liking.

By default the TUI now uses whatever color is configured for your xterm,
not something fixed as in the past, which was a common source of
complaints, that, unfortunately I only heard indirectly :-\

Ah, if you still need to configure the colors, use "default" so that it
will use whatever is the color configured in your
xterm/gnome-terminal/whatever profile.

For reference, the default set of colors now is (from
tools/perf/util/ui/browser.c):

static struct ui_browser__colorset {
        const char *name, *fg, *bg;
        int colorset;
} ui_browser__colorsets[] = {
        {
                .colorset = HE_COLORSET_TOP,
                .name     = "top",
                .fg       = "red",
                .bg       = "default",
        },
        {
                .colorset = HE_COLORSET_MEDIUM,
                .name     = "medium",
                .fg       = "green",
                .bg       = "default",
        },
        {
                .colorset = HE_COLORSET_NORMAL,
                .name     = "normal",
                .fg       = "default",
                .bg       = "default",
        },
        {
                .colorset = HE_COLORSET_SELECTED,
                .name     = "selected",
                .fg       = "black",
                .bg       = "lightgray",
        },
        {
                .colorset = HE_COLORSET_CODE,
                .name     = "code",
                .fg       = "blue",
                .bg       = "default",
        },

It should all be fixed up now, together with many other improvements
that should make the TUI and stdio default user experience similar up
till you start using the navigation keys to do things that only are
possible with a TUI, like folding/unfolding callchains, etc.

Please let me know about any other problem you may find with it!

- Arnaldo
