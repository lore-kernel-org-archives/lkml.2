Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0IAC6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:58:25 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60362 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754427Ab0IAC6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:58:20 -0400
Date: Tue, 31 Aug 2010 22:58:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Pauli Nieminen <ext-pauli.nieminen@nokia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Tony Lindgren <tony@atomide.com>,
        Jarkko Nikula <jhnikula@gmail.com>, linux-kernel@vger.kernel.org,
        Pauli <suokkos@gmail.com>
Subject: Re: IPC between application and xserver is causing extra context
	switches
Message-ID: <20100901025817.GA6200@Krystal>
References: <20100809150211.GA29771@burn-it>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20100809150211.GA29771@burn-it>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:51:18 up 221 days,  5:28,  3 users,  load average: 0.10, 0.07,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Pauli Nieminen (ext-pauli.nieminen@nokia.com) wrote:
> Hi,
> 
> While running rendering benchmark we noticed huge context switch numbers that
> were a lot larger than excepted. Numbers were showing 20-30 context switches
> per frame. Theoretical minimum context switches is less than 10.
> 
> Problem was traced using FineToothComp (FTC) [1]. Tracing down to per
> instruction view what happens in system.
> 
> Conext switches are relatively easy to track down from the trace
> visualization so it was easy to find out what was causing the extra context
> switches.
> 
>  * What application is doing when calling xserver?
> 
> Application opens unix socket connection to xserver. Communication is based
> on simple message protocol. Application does following call sequence when
> communicating to xserver.
> 
> writev(...) // Send message(s) to xserver
> 
> poll(...) // wait for response(s) from xserver
> 
> read(...) // read the response(s)
> 
>  * Where does extra context switches happen?
> 
> Application developer would except that only poll call would trigger context
> switch. But in worst case every system call is triggering context switch.
> 
> - writev()
> 
> writev does implicit context switch in kernel after writing to socket. This
> isn't perfect behavior for asynchronous IPC because application might want to
> queue up more messages before context switch.
> 
> This doesn't affect X communication because there is buffering implementation
> in xcb for asynchronous operations. But it might be good to fix for some
> other implementations that don't have buffering.
> 
> - poll()
> 
> But scheduling in writev backfires when poll is called. There is some X calls
> (DRI2GetBuffers etc) that takes very long to handle. While xserver is handlnig
> the request kernel decides to schedule client before there is response.
> 
> Now client executes very few instructions before hitting the poll. Now poll
> blocks because there is no response from xserver.

Well, actually, I just traced it with LTTng, and the situation is a little
weird. Xorg does a read() system call on the unix socket, which triggers a
wakeup that targets xwininfo which is waiting on a poll(). The poll wakes up for
a very short amount of time, returns back to the kernel, and schedules xorg
again to complete the read() (it actually returns 8 bytes, even weirder). Then
later xwininfo will be woken up by the writev system call (which is a little
more expected).

I'm attaching a snapshot showing the event list pinpointing the exact execution
sequence. Any thoughts ?

> 
> - read()
> 
> Application hits read soon after returning from poll. xserver has gone to
> sleep in select call waiting for multiple file descriptor.
> 
> When read call is returning from kernel unlocking the socket triggers xserver
> scheduling. This schedulnig never returns from kernel space but it iterates
> over all file descriptors that xserver is waiting for.
> 
>  * Test case
> 
> There is relatively simple test case attached that can check if kernel is
> scheduling too many times. Test case is xwininfo tool modified not to output
> anything. Running it with -root and -tree parameters is generating lots of
> request for xserver.
> 
> Compilation instructions are in  xwininfo.c. 
> 
> test.sh can be used to automatically test if there was too many extra
> scheduling. In perfect case scheduling should be only twice the number of
> request.
> 
>  * Where the bug has been seen?
> 
> I first saw this while doing development on arm. I have also tested a few x86
> kernels to see if problem can be reproduced there too. Problem was
> reproducing in most of configurations that I tested.
> 
> broken:
> 2.6.32 (ARM)
> 2.6.28 (x86 Debian Lenny)
> 2.6.35-rc4 (x86 vanila, Ubuntu Karmic user space)
> 
> But for my surprise I could find single working configuration that was my
> work desktop using Ubuntu kernel.
> 
> correctly working:
> 2.6.31 (x86 Ubuntu Karmic)

I'd be careful about bissection between a Ubuntu kernel and mainline. Ubuntu can
add many tweaks to their kernels. An example of a tweak that makes the test
"pass" is:

echo NO_WAKEUP_PREEMPT > /debugfs/sched_features
(with CONFIG_DEBUG_SCHED=y)

Thanks,

Mathieu

> 
>  * Bisecting failed
> 
> I tried to bisect if I could find the kernel commit that has fixed the
> problem for Ubuntu karmic but I hit problem that my self compiled kernels
> didn't boot. I don't have enough time now to try to do the bisecting.
> 
> If bisecting would help I can try to find some time.
> 
> 
> There is still open question if the bug is caused by userspace doing stupid
> stuff with unix socket or actual kernel problem. But my debugging is pointing
> to kernel problem because same userspace hits the bug with different kernel.
> 
> Pauli
> 
> [1] QT blog post explaining what can be done with FTC
> http://labs.trolltech.com/blogs/2009/09/29/exploring-qt-performance-on-arm-using-finetoothcomb/

> /**
>  * Compile: gcc -DHAVE_CONFIG_H -I. -g -O2 -o xwininfo xwininfo.c -lXext -lX11
>  * test case:
>  * 1. Count number of writes to xserver.
>  *  strace ./xwininfo -root -tree 2>&1 | grep writev | wc
>  * 2. Compare that value to number of context switches happening while running
>  *    xwininfo.
>  *  vmstat -n 1 & sleep 3; ./xwininfo -root -tree; sleep 3; killall vmstat
>  * 3. Compare how context switch numbers increase with number of runs
>  *  vmstat -n 1 & sleep 3; echo START; for i in 1 2; do ./xwininfo -root -tree; done; echo END; sleep 3; killall vmstat
>  *  vmstat -n 1 & sleep 3; echo START; for i in 1 2 3; do ./xwininfo -root -tree; done; echo END; sleep 3; killall vmstat
>  *  vmstat -n 1 & sleep 3; echo START; for i in 1 2 3 4 5; do ./xwininfo -root -tree; done; echo END; sleep 3; killall vmstat
>  **/
> 
> /* config.h.  Generated from config.h.in by configure.  */
> /* config.h.in.  Generated from configure.ac by autoheader.  */
> 
> /* Define to 1 if you have the `strlcat' function. */
> /* #undef HAVE_STRLCAT */
> 
> /* Name of package */
> #define PACKAGE "xwininfo"
> 
> /* Define to the address where bug reports for this package should be sent. */
> #define PACKAGE_BUGREPORT "https://bugs.freedesktop.org/enter_bug.cgi?product=xorg"
> 
> /* Define to the full name of this package. */
> #define PACKAGE_NAME "xwininfo"
> 
> /* Define to the full name and version of this package. */
> #define PACKAGE_STRING "xwininfo 1.0.4"
> 
> /* Define to the one symbol short name of this package. */
> #define PACKAGE_TARNAME "xwininfo"
> 
> /* Define to the version of this package. */
> #define PACKAGE_VERSION "1.0.4"
> 
> /* Major version of this package */
> #define PACKAGE_VERSION_MAJOR 1
> 
> /* Minor version of this package */
> #define PACKAGE_VERSION_MINOR 0
> 
> /* Patch version of this package */
> #define PACKAGE_VERSION_PATCHLEVEL 4
> 
> /* Version number of package */
> #define VERSION "1.0.4"
> 
> 
> /*
>  * Copyright 2007 Kim woelders
>  *
>  * Permission to use, copy, modify, distribute, and sell this software and its
>  * documentation for any purpose is hereby granted without fee, provided that
>  * the above copyright notice appear in all copies and that both that copyright
>  * notice and this permission notice appear in supporting documentation, and
>  * that the name of the copyright holders not be used in advertising or
>  * publicity pertaining to distribution of the software without specific,
>  * written prior permission.  The copyright holders make no representations
>  * about the suitability of this software for any purpose.  It is provided "as
>  * is" without express or implied warranty.
>  *
>  * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
>  * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
>  * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
>  * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
>  * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
>  * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
>  * OF THIS SOFTWARE.
>  */
> #ifndef _CLIENTWIN_H_
> #define _CLIENTWIN_H_
> 
> #include <X11/Xlib.h>
> 
> extern Window Find_Client(Display * dpy, Window root, Window target_win);
> 
> #endif
> 
> 
> /* $Xorg: dsimple.h,v 1.4 2001/02/09 02:05:54 xorgcvs Exp $ */
> /*
> 
> Copyright 1993, 1998  The Open Group
> 
> Permission to use, copy, modify, distribute, and sell this software and its
> documentation for any purpose is hereby granted without fee, provided that
> the above copyright notice appear in all copies and that both that
> copyright notice and this permission notice appear in supporting
> documentation.
> 
> The above copyright notice and this permission notice shall be included
> in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
> OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
> IN NO EVENT SHALL THE OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR
> OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> OTHER DEALINGS IN THE SOFTWARE.
> 
> Except as contained in this notice, the name of The Open Group shall
> not be used in advertising or otherwise to promote the sale, use or
> other dealings in this Software without prior written authorization
> from The Open Group.
> 
> */
> /* $XFree86: xc/programs/xlsfonts/dsimple.h,v 1.8 2002/12/24 17:43:01 tsi Exp $ */
> 
> /*
>  * Just_display.h: This file contains the definitions needed to use the
>  *                 functions in just_display.c.  It also declares the global
>  *                 variables dpy, screen, and program_name which are needed to
>  *                 use just_display.c.
>  *
>  * Written by Mark Lillibridge.   Last updated 7/1/87
>  *
>  * Send bugs, etc. to chariot@athena.mit.edu.
>  */
> 
>     /* Simple helper macros */
> #ifndef MAX
> #define MAX(a,b) (((a)>(b))?(a):(b))
> #endif /* MAX */
> #ifndef MIN
> #define MIN(a,b) (((a)<(b))?(a):(b))
> #endif /* MIN */
> 
>     /* Global variables used by routines in dsimple.c */
> 
> extern char *program_name;                   /* Name of this program */
> extern Display *dpy;                         /* The current display */
> extern int screen;                           /* The current screen */
> 
> #define INIT_NAME program_name=argv[0]        /* use this in main to setup
>                                                  program_name */
> 
>     /* Declaritions for functions in dsimple.c */
> 
> char *Get_Display_Name(int *, char **);
> Display *Open_Display(char *);
> void Setup_Display_And_Screen(int *, char **);
> void Close_Display(void);
> Window Select_Window_Args(int *, char **);
> void usage(void);
> 
> #define X_USAGE "[host:display]"              /* X arguments handled by
> 						 Get_Display_Name */
> 
> /*
>  * Other_stuff.h: Definitions of routines in other_stuff.
>  *
>  * Written by Mark Lillibridge.   Last updated 7/1/87
>  *
>  * Send bugs, etc. to chariot@athena.mit.edu.
>  */
> 
> Window Select_Window(Display *, int);
> Window Window_With_Name(Display *, Window, char *);
> #ifdef __GNUC__
> void Fatal_Error(char *, ...) __attribute__((__noreturn__));
> #else
> void Fatal_Error(char *, ...);
> #endif
> 
> /*
>  * Copyright 2007 Kim woelders
>  *
>  * Permission to use, copy, modify, distribute, and sell this software and its
>  * documentation for any purpose is hereby granted without fee, provided that
>  * the above copyright notice appear in all copies and that both that copyright
>  * notice and this permission notice appear in supporting documentation, and
>  * that the name of the copyright holders not be used in advertising or
>  * publicity pertaining to distribution of the software without specific,
>  * written prior permission.  The copyright holders make no representations
>  * about the suitability of this software for any purpose.  It is provided "as
>  * is" without express or implied warranty.
>  *
>  * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
>  * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
>  * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
>  * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
>  * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
>  * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
>  * OF THIS SOFTWARE.
>  */
> #include <X11/Xatom.h>
> #include <X11/Xlib.h>
> 
> static Atom atom_wm_state = None;
> 
> /*
>  * Check if window has given property
>  */
> static Bool
> Window_Has_Property(Display * dpy, Window win, Atom atom)
> {
>     Atom type_ret;
>     int format_ret;
>     unsigned char *prop_ret;
>     unsigned long bytes_after, num_ret;
> 
>     type_ret = None;
>     prop_ret = NULL;
>     XGetWindowProperty(dpy, win, atom, 0, 0, False, AnyPropertyType,
>                        &type_ret, &format_ret, &num_ret,
>                        &bytes_after, &prop_ret);
>     if (prop_ret)
>         XFree(prop_ret);
> 
>     return (type_ret != None) ? True : False;
> }
> 
> /*
>  * Check if window is viewable
>  */
> static Bool
> Window_Is_Viewable(Display * dpy, Window win)
> {
>     Bool ok;
>     XWindowAttributes xwa;
> 
>     XGetWindowAttributes(dpy, win, &xwa);
> 
>     ok = (xwa.class == InputOutput) && (xwa.map_state == IsViewable);
> 
>     return ok;
> }
> 
> /*
>  * Find a window that has WM_STATE set in the window tree below win.
>  * Unmapped/unviewable windows are not considered valid matches.
>  * Children are searched in top-down stacking order.
>  * The first matching window is returned, None if no match is found.
>  */
> Window
> Find_Client_In_Children(Display * dpy, Window win)
> {
>     Window root, parent;
>     Window *children;
>     unsigned int n_children;
>     int i;
> 
>     if (!XQueryTree(dpy, win, &root, &parent, &children, &n_children))
>         return None;
>     if (!children)
>         return None;
> 
>     /* Check each child for WM_STATE and other validity */
>     win = None;
>     for (i = (int) n_children - 1; i >= 0; i--) {
>         if (!Window_Is_Viewable(dpy, children[i])) {
>             children[i] = None; /* Don't bother descending into this one */
>             continue;
>         }
>         if (!Window_Has_Property(dpy, children[i], atom_wm_state))
>             continue;
> 
>         /* Got one */
>         win = children[i];
>         goto done;
>     }
> 
>     /* No children matched, now descend into each child */
>     for (i = (int) n_children - 1; i >= 0; i--) {
>         if (children[i] == None)
>             continue;
>         win = Find_Client_In_Children(dpy, children[i]);
>         if (win != None)
>             break;
>     }
> 
>   done:
>     XFree(children);
> 
>     return win;
> }
> 
> /*
>  * Find virtual roots (_NET_VIRTUAL_ROOTS)
>  */
> unsigned long *
> Find_Roots(Display * dpy, Window root, unsigned int *num)
> {
>     Atom type_ret;
>     int format_ret;
>     unsigned char *prop_ret;
>     unsigned long bytes_after, num_ret;
>     Atom atom;
> 
>     *num = 0;
>     atom = XInternAtom(dpy, "_NET_VIRTUAL_ROOTS", False);
>     if (!atom)
>         return NULL;
> 
>     type_ret = None;
>     prop_ret = NULL;
>     if (XGetWindowProperty(dpy, root, atom, 0, 0x7fffffff, False,
>                            XA_WINDOW, &type_ret, &format_ret, &num_ret,
>                            &bytes_after, &prop_ret) != Success)
>         return NULL;
> 
>     if (prop_ret && type_ret == XA_WINDOW && format_ret == 32) {
>         *num = num_ret;
>         return ((unsigned long *) prop_ret);
>     }
>     if (prop_ret)
>         XFree(prop_ret);
> 
>     return NULL;
> }
> 
> /*
>  * Find child window at pointer location
>  */
> static Window
> Find_Child_At_Pointer(Display * dpy, Window win)
> {
>     Window root_return, child_return;
>     int dummyi;
>     unsigned int dummyu;
> 
>     XQueryPointer(dpy, win, &root_return, &child_return,
>                   &dummyi, &dummyi, &dummyi, &dummyi, &dummyu);
> 
>     return child_return;
> }
> 
> /*
>  * Find client window at pointer location
>  *
>  * root   is the root window.
>  * subwin is the subwindow reported by a ButtonPress event on root.
>  *
>  * If the WM uses virtual roots subwin may be a virtual root.
>  * If so, we descend the window stack at the pointer location and assume the
>  * child is the client or one of its WM frame windows.
>  * This will of course work only if the virtual roots are children of the real
>  * root.
>  */
> Window
> Find_Client(Display * dpy, Window root, Window subwin)
> {
>     unsigned long *roots;
>     unsigned int i, n_roots;
>     Window win;
> 
>     /* Check if subwin is a virtual root */
>     roots = Find_Roots(dpy, root, &n_roots);
>     for (i = 0; i < n_roots; i++) {
>         if (subwin != roots[i])
>             continue;
>         win = Find_Child_At_Pointer(dpy, subwin);
>         if (win == None)
>             return subwin;      /* No child - Return virtual root. */
>         subwin = win;
>         break;
>     }
>     if (roots)
>         XFree(roots);
> 
>     if (atom_wm_state == None) {
>         atom_wm_state = XInternAtom(dpy, "WM_STATE", False);
>         if (!atom_wm_state)
>             return subwin;
>     }
> 
>     /* Check if subwin has WM_STATE */
>     if (Window_Has_Property(dpy, subwin, atom_wm_state))
>         return subwin;
> 
>     /* Attempt to find a client window in subwin's children */
>     win = Find_Client_In_Children(dpy, subwin);
>     if (win != None)
>         return win;             /* Found a client */
> 
>     /* Did not find a client */
>     return subwin;
> }
> /* $Xorg: dsimple.c,v 1.4 2001/02/09 02:05:54 xorgcvs Exp $ */
> /*
> 
> Copyright 1993, 1998  The Open Group
> 
> Permission to use, copy, modify, distribute, and sell this software and its
> documentation for any purpose is hereby granted without fee, provided that
> the above copyright notice appear in all copies and that both that
> copyright notice and this permission notice appear in supporting
> documentation.
> 
> The above copyright notice and this permission notice shall be included
> in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
> OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
> IN NO EVENT SHALL THE OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR
> OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> OTHER DEALINGS IN THE SOFTWARE.
> 
> Except as contained in this notice, the name of The Open Group shall
> not be used in advertising or otherwise to promote the sale, use or
> other dealings in this Software without prior written authorization
> from The Open Group.
> 
> */
> /* $XFree86: xc/programs/xlsfonts/dsimple.c,v 3.6 2001/12/14 20:02:09 dawes Exp $ */
> 
> #include <X11/Xos.h>
> #include <X11/Xlib.h>
> #include <X11/Xutil.h>
> #include <X11/cursorfont.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <stdarg.h>
> /*
>  * Other_stuff.h: Definitions of routines in other_stuff.
>  *
>  * Written by Mark Lillibridge.   Last updated 7/1/87
>  */
> 
> 
> /*
>  * Just_display: A group of routines designed to make the writing of simple
>  *               X11 applications which open a display but do not open
>  *               any windows much faster and easier.  Unless a routine says
>  *               otherwise, it may be assumed to require program_name, dpy,
>  *               and screen already defined on entry.
>  *
>  * Written by Mark Lillibridge.   Last updated 7/1/87
>  */
> 
> 
> /* This stuff is defined in the calling program by just_display.h */
> char    *program_name = "unknown_program";
> Display *dpy = NULL;
> int      screen = 0;
> 
> 
> /*
>  * Get_Display_Name (argc, argv) Look for -display, -d, or host:dpy (obselete)
>  * If found, remove it from command line.  Don't go past a lone -.
>  */
> char *Get_Display_Name(
>     int *pargc,  /* MODIFIED */
>     char **argv) /* MODIFIED */
> {
>     int argc = *pargc;
>     char **pargv = argv+1;
>     char *displayname = NULL;
>     int i;
> 
>     for (i = 1; i < argc; i++) {
> 	char *arg = argv[i];
> 
> 	if (!strcmp (arg, "-display") || !strcmp (arg, "-d")) {
> 	    if (++i >= argc) usage ();
> 
> 	    displayname = argv[i];
> 	    *pargc -= 2;
> 	    continue;
> 	}
> 	if (!strcmp(arg,"-")) {
> 		while (i<argc)
> 			*pargv++ = argv[i++];
> 		break;
> 	}
> 	*pargv++ = arg;
>     }
> 
>     *pargv = NULL;
>     return (displayname);
> }
> 
> 
> 
> /*
>  * Open_Display: Routine to open a display with correct error handling.
>  *               Does not require dpy or screen defined on entry.
>  */
> Display *Open_Display(char *display_name)
> {
> 	Display *d;
> 
> 	d = XOpenDisplay(display_name);
> 	if (d == NULL) {
> 	    fprintf (stderr, "%s:  unable to open display '%s'\n",
> 		     program_name, XDisplayName (display_name));
> 	    usage ();
> 	    /* doesn't return */
> 	}
> 
> 	return(d);
> }
> 
> 
> /*
>  * Setup_Display_And_Screen: This routine opens up the correct display (i.e.,
>  *                           it calls Get_Display_Name) and then stores a
>  *                           pointer to it in dpy.  The default screen
>  *                           for this display is then stored in screen.
>  *                           Does not require dpy or screen defined.
>  */
> void Setup_Display_And_Screen(
>     int *argc,      /* MODIFIED */
>     char **argv)    /* MODIFIED */
> {
> 	char *displayname = NULL;
>         
>         displayname = Get_Display_Name(argc, argv);
> 	dpy = Open_Display (displayname);
> 	screen = XDefaultScreen(dpy);
> }
> 
> /*
>  * Close_Display: Close display
>  */
> void Close_Display(void)
> {
>     if (dpy == NULL)
>       return;
>       
>     XCloseDisplay(dpy);
>     dpy = NULL;
> }
> 
> 
> /*
>  * Select_Window_Args: a rountine to provide a common interface for
>  *                     applications that need to allow the user to select one
>  *                     window on the screen for special consideration.
>  *                     This routine implements the following command line
>  *                     arguments:
>  *
>  *                       -root            Selects the root window.
>  *                       -id <id>         Selects window with id <id>. <id> may
>  *                                        be either in decimal or hex.
>  *                       -name <name>     Selects the window with name <name>.
>  *
>  *                     Call as Select_Window_Args(&argc, argv) in main before
>  *                     parsing any of your program's command line arguments.
>  *                     Select_Window_Args will remove its arguments so that
>  *                     your program does not have to worry about them.
>  *                     The window returned is the window selected or 0 if
>  *                     none of the above arguments was present.  If 0 is
>  *                     returned, Select_Window should probably be called after
>  *                     all command line arguments, and other setup is done.
>  *                     For examples of usage, see xwininfo, xwd, or xprop.
>  */
> Window Select_Window_Args(
>     int *rargc,
>     char **argv)
> #define ARGC (*rargc)
> {
> 	int nargc=1;
> 	int argc;
> 	char **nargv;
> 	Window w=0;
> 
> 	nargv = argv+1; argc = ARGC;
> #define OPTION argv[0]
> #define NXTOPTP ++argv, --argc>0
> #define NXTOPT if (++argv, --argc==0) usage()
> #define COPYOPT nargv++[0]=OPTION, nargc++
> 
> 	while (NXTOPTP) {
> 		if (!strcmp(OPTION, "-")) {
> 			COPYOPT;
> 			while (NXTOPTP)
> 			  COPYOPT;
> 			break;
> 		}
> 		if (!strcmp(OPTION, "-root")) {
> 			w=RootWindow(dpy, screen);
> 			continue;
> 		}
> 		if (!strcmp(OPTION, "-name")) {
> 			NXTOPT;
> 			w = Window_With_Name(dpy, RootWindow(dpy, screen),
> 					     OPTION);
> 			if (!w)
> 			  Fatal_Error("No window with name %s exists!",OPTION);
> 			continue;
> 		}
> 		if (!strcmp(OPTION, "-id")) {
> 			NXTOPT;
> 			w=0;
> 			sscanf(OPTION, "0x%lx", &w);
> 			if (!w)
> 			  sscanf(OPTION, "%lu", &w);
> 			if (!w)
> 			  Fatal_Error("Invalid window id format: %s.", OPTION);
> 			continue;
> 		}
> 		COPYOPT;
> 	}
> 	ARGC = nargc;
> 	
> 	return(w);
> }
> 
> /*
>  * Other_stuff: A group of routines which do common X11 tasks.
>  *
>  * Written by Mark Lillibridge.   Last updated 7/1/87
>  */
> 
> 
> /*
>  * Routine to let user select a window using the mouse
>  */
> 
> Window Select_Window(Display *dpy, int descend)
> {
>   int status;
>   Cursor cursor;
>   XEvent event;
>   Window target_win = None, root = RootWindow(dpy,screen);
>   int buttons = 0;
> 
>   /* Make the target cursor */
>   cursor = XCreateFontCursor(dpy, XC_crosshair);
> 
>   /* Grab the pointer using target cursor, letting it room all over */
>   status = XGrabPointer(dpy, root, False,
> 			ButtonPressMask|ButtonReleaseMask, GrabModeSync,
> 			GrabModeAsync, root, cursor, CurrentTime);
>   if (status != GrabSuccess) Fatal_Error("Can't grab the mouse.");
> 
>   /* Let the user select a window... */
>   while ((target_win == None) || (buttons != 0)) {
>     /* allow one more event */
>     XAllowEvents(dpy, SyncPointer, CurrentTime);
>     XWindowEvent(dpy, root, ButtonPressMask|ButtonReleaseMask, &event);
>     switch (event.type) {
>     case ButtonPress:
>       if (target_win == None) {
> 	target_win = event.xbutton.subwindow; /* window selected */
> 	if (target_win == None) target_win = root;
>       }
>       buttons++;
>       break;
>     case ButtonRelease:
>       if (buttons > 0) /* there may have been some down before we started */
> 	buttons--;
>        break;
>     }
>   } 
> 
>   XUngrabPointer(dpy, CurrentTime);      /* Done with pointer */
> 
>   if (!descend || (target_win == root))
>     return(target_win);
> 
>   target_win = Find_Client(dpy, root, target_win);
> 
>   return(target_win);
> }
> 
> 
> /*
>  * Window_With_Name: routine to locate a window with a given name on a display.
>  *                   If no window with the given name is found, 0 is returned.
>  *                   If more than one window has the given name, the first
>  *                   one found will be returned.  Only top and its subwindows
>  *                   are looked at.  Normally, top should be the RootWindow.
>  */
> Window Window_With_Name(
>     Display *dpy,
>     Window top,
>     char *name)
> {
> 	Window *children, dummy;
> 	unsigned int nchildren;
> 	int i;
> 	Window w=0;
> 	char *window_name;
> 
> 	if (XFetchName(dpy, top, &window_name) && !strcmp(window_name, name))
> 	  return(top);
> 
> 	if (!XQueryTree(dpy, top, &dummy, &dummy, &children, &nchildren))
> 	  return(0);
> 
> 	for (i=0; i<nchildren; i++) {
> 		w = Window_With_Name(dpy, children[i], name);
> 		if (w)
> 		  break;
> 	}
> 	if (children) XFree ((char *)children);
> 	return(w);
> }
> 
> 
> /*
>  * Standard fatal error routine - call like printf
>  * Does not require dpy or screen defined.
>  */
> void Fatal_Error(char *msg, ...)
> {
> 	va_list args;
> 	fflush(stdout);
> 	fflush(stderr);
> 	fprintf(stderr, "%s: error: ", program_name);
> 	va_start(args, msg);
> 	vfprintf(stderr, msg, args);
> 	va_end(args);
> 	fprintf(stderr, "\n");
>         Close_Display();
> 	exit(EXIT_FAILURE);
> }
> /* $XdotOrg: $ */
> /* $Xorg: xwininfo.c,v 1.4 2001/02/09 02:06:04 xorgcvs Exp $ */
> /*
> 
> Copyright 1987, 1998  The Open Group
> Copyright 1999 Sun Microsystems, Inc.
> 
> Permission to use, copy, modify, distribute, and sell this software and its
> documentation for any purpose is hereby granted without fee, provided that
> the above copyright notice appear in all copies and that both that
> copyright notice and this permission notice appear in supporting
> documentation.
> 
> The above copyright notice and this permission notice shall be included
> in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
> OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
> OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
> HOLDERS INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL
> INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING
> FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
> NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
> WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> 
> Except as contained in this notice, the name of a copyright holder
> shall not be used in advertising or otherwise to promote the sale, use
> or other dealings in this Software without prior written authorization
> of the copyright holder.
> 
> */
> /* $XFree86: xc/programs/xwininfo/xwininfo.c,v 1.9 2003/09/09 22:08:25 herrb Exp $ */
> 
> 
> /*
>  * xwininfo.c	- MIT Project Athena, X Window system window
>  *		  information utility.
>  *
>  *
>  *	This program will report all relevant information
>  *	about a specific window.
>  *
>  *  Author:	Mark Lillibridge, MIT Project Athena
>  *		16-Jun-87
>  */
> 
> #include <X11/Xlib.h>
> #include <X11/Xutil.h>
> #include <X11/Xatom.h>
> #include <X11/Xos.h>
> #include <X11/extensions/shape.h>
> #ifndef NO_I18N
> #include <X11/Xlocale.h>
> #endif
> #include <stdio.h>
> #include <stdlib.h>
> 
> /* Include routines to handle parsing defaults */
> 
> #define printf /* */
> 
> typedef struct {
> 	long code;
> 	const char *name;
> } binding;
> 
> static void scale_init(void);
> static char *nscale(int, int, int, char *, size_t);
> static char *xscale(int);
> static char *yscale(int);
> static char *bscale(int);
> static int bad_window_handler(Display *, XErrorEvent *);
> int main(int, char **);
> static const char *LookupL(long, const binding *);
> static const char *Lookup(int, const binding *);
> static void Display_Window_Id(Window, int);
> static void Display_Stats_Info(Window);
> static void Display_Bits_Info(Window);
> static void Display_Event_Mask(long);
> static void Display_Events_Info(Window);
> static void Display_Tree_Info(Window, int);
> static void display_tree_info_1(Window, int, int);
> static void Display_Hints(XSizeHints *);
> static void Display_Size_Hints(Window);
> static void Display_Window_Shape(Window);
> static void Display_WM_Info(Window);
> 
> static char *window_id_format = "0x%lx";
> 
> #ifndef HAVE_STRLCAT
> static size_t strlcat(char *dst, const char *src, size_t dstsize)
> {
>     size_t sd = strlen(dst);
>     size_t ss = strlen(src);
>     size_t s = sd + ss;
>     
>     if (s < dstsize) {
> 	strcpy(dst + sd, src);
>     } else {
> 	strncpy(dst + sd, src, dstsize-sd-1);
> 	dst[dstsize] = '\0';
>     }
>     return s;
> }
> #endif
> 
> /*
>  * Report the syntax for calling xwininfo:
>  */
> void
> usage(void)
> {
>     fprintf (stderr,
> 	"usage:  %s [-options ...]\n\n", program_name);
>     fprintf (stderr,
> 	"where options include:\n");
>     fprintf (stderr,
> 	"    -help                print this message\n");
>     fprintf (stderr,
> 	"    -display host:dpy    X server to contact\n");
>     fprintf (stderr,
> 	"    -root                use the root window\n");
>     fprintf (stderr,
> 	"    -id windowid         use the window with the specified id\n");
>     fprintf (stderr,
> 	"    -name windowname     use the window with the specified name\n");
>     fprintf (stderr,
> 	"    -int                 print window id in decimal\n");
>     fprintf (stderr,
> 	"    -children            print parent and child identifiers\n");
>     fprintf (stderr,
> 	"    -tree                print children identifiers recursively\n");
>     fprintf (stderr,
> 	"    -stats               print window geometry [DEFAULT]\n");
>     fprintf (stderr,
> 	"    -bits                print window pixel information\n");
>     fprintf (stderr,
> 	"    -events              print events selected for on window\n");
>     fprintf (stderr,
> 	"    -size                print size hints\n");
>     fprintf (stderr,
> 	"    -wm                  print window manager hints\n");
>     fprintf (stderr,
> 	"    -shape               print shape extents\n");
>     fprintf (stderr,
> 	"    -frame               don't ignore window manager frames\n");
>     fprintf (stderr,
> 	"    -english             print sizes in english units\n");
>     fprintf (stderr,
> 	"    -metric              print sizes in metric units\n");
>     fprintf (stderr,
> 	"    -all                 -tree, -stats, -bits, -events, -wm, -size, -shape\n");
>     fprintf (stderr,
> 	"\n");
>     exit (1);
> }
> 
> /*
>  * pixel to inch, metric converter.
>  * Hacked in by Mark W. Eichin <eichin@athena> [eichin:19880619.1509EST]
>  *
>  * Simply put: replace the old numbers with string print calls.
>  * Returning a local string is ok, since we only ever get called to
>  * print one x and one y, so as long as they don't collide, they're
>  * fine. This is not meant to be a general purpose routine.
>  *
>  */
> 
> #define getdsp(var,fn) var = fn(dpy, DefaultScreen(dpy))
> static int xp=0, xmm=0;
> static int yp=0, ymm=0;
> static int bp=0, bmm=0;
> static int english = 0, metric = 0;
> 
> static void
> scale_init(void)
> {
>   getdsp(yp,  DisplayHeight);
>   getdsp(ymm, DisplayHeightMM);
>   getdsp(xp,  DisplayWidth);
>   getdsp(xmm, DisplayWidthMM);
>   bp  = xp  + yp;
>   bmm = xmm + ymm;
> }
> 
> #define MILE (5280*12)
> #define YARD (3*12)
> #define FOOT (12)
> 
> static char *
> nscale(int n, int np, int nmm, char *nbuf, size_t nbufsize)
> {
>     int s;
>     snprintf(nbuf, nbufsize, "%d", n);
>     
>     if (metric||english) {
> 	s = strlcat(nbuf, " (", nbufsize);
> 
> 	if (metric) {
> 	    snprintf(nbuf+s, nbufsize-s, "%.2f mm%s",
> 		     ((double) n)*nmm/np, english ? "; " : "");
> 	}
> 	if (english) {
> 	    double inch_frac;
> 	    Bool printed_anything = False;
> 	    int mi, yar, ft, inr;
> 
> 	    inch_frac = ((double) n)*(nmm/25.4)/np;
> 	    inr = (int)inch_frac;
> 	    inch_frac -= (double)inr;
> 	    if (inr >= MILE) {
> 		mi = inr/MILE;
> 		inr %= MILE;
> 		s = strlen(nbuf);
> 		snprintf(nbuf+s, nbufsize-s, "%d %s(?!?)",
> 			 mi, (mi==1) ? "mile" : "miles");
> 		printed_anything = True;
> 	    }
> 	    if (inr >= YARD) {
> 		yar = inr/YARD;
> 		inr %= YARD;
> 		if (printed_anything)
> 		    strlcat(nbuf, ", ", nbufsize);
> 		s = strlen(nbuf);
> 		snprintf(nbuf+s, nbufsize-s, "%d %s",
> 			yar, (yar==1) ? "yard" : "yards");
> 		printed_anything = True;
> 	    }
> 	    if (inr >= FOOT) {
> 		ft = inr/FOOT;
> 		inr  %= FOOT;
> 		if (printed_anything)
> 		    strlcat(nbuf, ", ", nbufsize);
> 		s = strlen(nbuf);
> 		snprintf(nbuf+s, nbufsize-s, "%d %s",
> 			ft, (ft==1) ? "foot" : "feet");
> 		printed_anything = True;
> 	    }
> 	    if (!printed_anything || inch_frac != 0.0 || inr != 0) {
> 		if (printed_anything)
> 		    strlcat(nbuf, ", ", nbufsize);
> 		s = strlen(nbuf);		
> 		snprintf(nbuf+s, nbufsize-s, "%.2f inches", inr+inch_frac);
> 	    }
> 	}
> 	strlcat (nbuf, ")", nbufsize);
>     }
>     return(nbuf);
> }	  
>   
> static char xbuf[BUFSIZ];
> static char *
> xscale(int x)
> {
>   if(!xp) {
>     scale_init();
>   }
>   return(nscale(x, xp, xmm, xbuf, sizeof(xbuf)));
> }
> 
> static char ybuf[BUFSIZ];
> static char *
> yscale(int y)
> {
>   if(!yp) {
>     scale_init();
>   }
>   return(nscale(y, yp, ymm, ybuf, sizeof(ybuf)));
> }
> 
> static char bbuf[BUFSIZ];
> static char *
> bscale(int b)
> {
>   if(!bp) {
>     scale_init();
>   }
>   return(nscale(b, bp, bmm, bbuf, sizeof(bbuf)));
> }
> 
> /* end of pixel to inch, metric converter */
> 
> /* This handler is enabled when we are checking
>    to see if the -id the user specified is valid. */
> 
> /* ARGSUSED */
> static int
> bad_window_handler(Display *disp, XErrorEvent *err)
> {
>     char badid[20];
> 
>     snprintf(badid, sizeof(badid), window_id_format, err->resourceid);
>     Fatal_Error("No such window with id %s.", badid);
>     exit (1);
>     return 0;
> }
> 
> 
> int
> main(int argc, char **argv)
> {
>   register int i;
>   int tree = 0, stats = 0, bits = 0, events = 0, wm = 0, size  = 0, shape = 0;
>   int frame = 0, children = 0;
>   Window window;
> 
>   INIT_NAME;
> 
> #ifndef NO_I18N
>   {
>      char *lc;
>      lc = setlocale(LC_ALL, "");
>      if(!lc)
>         fprintf(stderr, "can not set locale properly\n");
>   }
> #endif
> 
>   /* Open display, handle command line arguments */
>   Setup_Display_And_Screen(&argc, argv);
> 
>   /* Get window selected on command line, if any */
>   window = Select_Window_Args(&argc, argv);
> 
>   /* Handle our command line arguments */
>   for (i = 1; i < argc; i++) {
>     if (!strcmp(argv[i], "-help"))
>       usage();
>     if (!strcmp(argv[i], "-int")) {
>       window_id_format = "%ld";
>       continue;
>     }
>     if (!strcmp(argv[i], "-children")) {
>       children = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-tree")) {
>       tree = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-stats")) {
>       stats = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-bits")) {
>       bits = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-events")) {
>       events = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-wm")) {
>       wm = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-frame")) {
>       frame = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-size")) {
>       size = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-shape")) {
>       shape = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-english")) {
>       english = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-metric")) {
>       metric = 1;
>       continue;
>     }
>     if (!strcmp(argv[i], "-all")) {
>       tree = stats = bits = events = wm = size = shape = 1;
>       continue;
>     }
>     usage();
>   }
> 
>   /* If no window selected on command line, let user pick one the hard way */
>   if (!window) {
> 	  printf("\n");
> 	  printf("xwininfo: Please select the window about which you\n");
> 	  printf("          would like information by clicking the\n");
> 	  printf("          mouse in that window.\n");
> 	  window = Select_Window(dpy, !frame);
>   }
> 
>   /*
>    * Do the actual displaying as per parameters
>    */
>   if (!(children || tree || bits || events || wm || size))
>     stats = 1;
> 
>   /*
>    * make sure that the window is valid
>    */
>   {
>     Window root;
>     int x, y;
>     unsigned width, height, bw, depth;
>     XErrorHandler old_handler;
> 
>     old_handler = XSetErrorHandler(bad_window_handler);
>     XGetGeometry (dpy, window, &root, &x, &y, &width, &height, &bw, &depth);
>     XSync (dpy, False);
>     (void) XSetErrorHandler(old_handler);
>   }
> 
>   printf("\nxwininfo: Window id: ");
>   Display_Window_Id(window, True);
>   if (children || tree)
>     Display_Tree_Info(window, tree);
>   if (stats)
>     Display_Stats_Info(window);
>   if (bits)
>     Display_Bits_Info(window);
>   if (events)
>     Display_Events_Info(window);
>   if (wm)
>     Display_WM_Info(window);
>   if (size)
>     Display_Size_Hints(window);
>   if (shape)
>     Display_Window_Shape(window);
>   printf("\n");
>   exit(0);
> }
> 
> 
> /*
>  * Lookup: lookup a code in a table.
>  */
> static char _lookup_buffer[100];
> 
> static const char *
> LookupL(long code, const binding *table)
> {
> 	const char *name;
> 
> 	snprintf(_lookup_buffer, sizeof(_lookup_buffer),
> 		 "unknown (code = %ld. = 0x%lx)", code, code);
> 	name = _lookup_buffer;
> 
> 	while (table->name) {
> 		if (table->code == code) {
> 			name = table->name;
> 			break;
> 		}
> 		table++;
> 	}
> 
> 	return(name);
> }
> 
> static const char *
> Lookup(int code, const binding *table)
> {
>     return LookupL((long)code, table);
> }
> 
> /*
>  * Routine to display a window id in dec/hex with name if window has one
>  */
> 
> static void
> Display_Window_Id(Window window, Bool newline_wanted)
> {
> #ifdef NO_I18N
>     char *win_name;
> #else
>     XTextProperty tp;
> #endif
>     
>     printf(window_id_format, window);         /* print id # in hex/dec */
> 
>     if (!window) {
> 	printf(" (none)");
>     } else {
> 	if (window == RootWindow(dpy, screen)) {
> 	    printf(" (the root window)");
> 	}
> #ifdef NO_I18N
> 	if (!XFetchName(dpy, window, &win_name)) { /* Get window name if any */
> 	    printf(" (has no name)");
> 	} else if (win_name) {
> 	    printf(" \"%s\"", win_name);
> 	    XFree(win_name);
> 	}
> #else
> 	if (!XGetWMName(dpy, window, &tp)) { /* Get window name if any */
> 	    printf(" (has no name)");
>         } else if (tp.nitems > 0) {
>             printf(" \"");
>             {
>                 int count = 0, i, ret;
>                 char **list = NULL;
>                 ret = XmbTextPropertyToTextList(dpy, &tp, &list, &count);
>                 if((ret == Success || ret > 0) && list != NULL){
>                     for(i=0; i<count; i++)
>                         printf("%s", list[i]);
>                     XFreeStringList(list);
>                 } else {
>                     printf("%s", tp.value);
>                 }
>             }
>             printf("\"");
> 	}
> #endif
> 	else
> 	    printf(" (has no name)");
>     }
> 
>     if (newline_wanted)
> 	printf("\n");
> 
>     return;
> }
> 
> 
> /*
>  * Display Stats on window
>  */
> static const binding _window_classes[] = {
> 	{ InputOutput, "InputOutput" },
> 	{ InputOnly, "InputOnly" },
>         { 0, 0 } };
> 
> static const binding _map_states[] = {
> 	{ IsUnmapped, "IsUnMapped" },
> 	{ IsUnviewable, "IsUnviewable" },
> 	{ IsViewable, "IsViewable" },
> 	{ 0, 0 } };
> 
> static const binding _backing_store_states[] = {
> 	{ NotUseful, "NotUseful" },
> 	{ WhenMapped, "WhenMapped" },
> 	{ Always, "Always" },
> 	{ 0, 0 } };
> 
> static const binding _bit_gravity_states[] = {
> 	{ ForgetGravity, "ForgetGravity" },
> 	{ NorthWestGravity, "NorthWestGravity" },
> 	{ NorthGravity, "NorthGravity" },
> 	{ NorthEastGravity, "NorthEastGravity" },
> 	{ WestGravity, "WestGravity" },
> 	{ CenterGravity, "CenterGravity" },
> 	{ EastGravity, "EastGravity" },
> 	{ SouthWestGravity, "SouthWestGravity" },
> 	{ SouthGravity, "SouthGravity" },
> 	{ SouthEastGravity, "SouthEastGravity" },
> 	{ StaticGravity, "StaticGravity" },
> 	{ 0, 0 }};
> 
> static const binding _window_gravity_states[] = {
> 	{ UnmapGravity, "UnmapGravity" },
> 	{ NorthWestGravity, "NorthWestGravity" },
> 	{ NorthGravity, "NorthGravity" },
> 	{ NorthEastGravity, "NorthEastGravity" },
> 	{ WestGravity, "WestGravity" },
> 	{ CenterGravity, "CenterGravity" },
> 	{ EastGravity, "EastGravity" },
> 	{ SouthWestGravity, "SouthWestGravity" },
> 	{ SouthGravity, "SouthGravity" },
> 	{ SouthEastGravity, "SouthEastGravity" },
> 	{ StaticGravity, "StaticGravity" },
> 	{ 0, 0 }};
> 
> static const binding _visual_classes[] = {
> 	{ StaticGray, "StaticGray" },
> 	{ GrayScale, "GrayScale" },
> 	{ StaticColor, "StaticColor" },
> 	{ PseudoColor, "PseudoColor" },
> 	{ TrueColor, "TrueColor" },
> 	{ DirectColor, "DirectColor" },
> 	{ 0, 0 }};
> 
> static void
> Display_Stats_Info(Window window)
> {
>   XWindowAttributes win_attributes;
>   XVisualInfo vistemplate, *vinfo;
>   XSizeHints hints;
>   int dw = DisplayWidth (dpy, screen), dh = DisplayHeight (dpy, screen);
>   int rx, ry, xright, ybelow;
>   int showright = 0, showbelow = 0;
>   Status status;
>   Window wmframe;
>   int junk;
>   long longjunk;
>   Window junkwin;
> 
>   if (!XGetWindowAttributes(dpy, window, &win_attributes))
>     Fatal_Error("Can't get window attributes.");
>   vistemplate.visualid = XVisualIDFromVisual(win_attributes.visual);
>   vinfo = XGetVisualInfo(dpy, VisualIDMask, &vistemplate, &junk);
> 
>   (void) XTranslateCoordinates (dpy, window, win_attributes.root, 
> 				-win_attributes.border_width,
> 				-win_attributes.border_width,
> 				&rx, &ry, &junkwin);
> 				
>   xright = (dw - rx - win_attributes.border_width * 2 -
> 	    win_attributes.width);
>   ybelow = (dh - ry - win_attributes.border_width * 2 -
> 	    win_attributes.height);
> 
>   printf("\n");
>   printf("  Absolute upper-left X:  %s\n", xscale(rx));
>   printf("  Absolute upper-left Y:  %s\n", yscale(ry));
>   printf("  Relative upper-left X:  %s\n", xscale(win_attributes.x));
>   printf("  Relative upper-left Y:  %s\n", yscale(win_attributes.y));
>   printf("  Width: %s\n", xscale(win_attributes.width));
>   printf("  Height: %s\n", yscale(win_attributes.height));
>   printf("  Depth: %d\n", win_attributes.depth);
>   printf("  Visual Class: %s\n", Lookup(vinfo->class, _visual_classes));
>   printf("  Border width: %s\n", bscale(win_attributes.border_width));
>   printf("  Class: %s\n",
>   	 Lookup(win_attributes.class, _window_classes));
>   printf("  Colormap: 0x%lx (%sinstalled)\n", 
> 	 win_attributes.colormap, win_attributes.map_installed ? "" : "not ");
>   printf("  Bit Gravity State: %s\n",
>   	 Lookup(win_attributes.bit_gravity, _bit_gravity_states));
>   printf("  Window Gravity State: %s\n",
>   	 Lookup(win_attributes.win_gravity, _window_gravity_states));
>   printf("  Backing Store State: %s\n",
>   	 Lookup(win_attributes.backing_store, _backing_store_states));
>   printf("  Save Under State: %s\n",
>   	 win_attributes.save_under ? "yes" : "no");
>   printf("  Map State: %s\n",
> 	 Lookup(win_attributes.map_state, _map_states));
>   printf("  Override Redirect State: %s\n",
>   	 win_attributes.override_redirect ? "yes" : "no");
>   printf("  Corners:  +%d+%d  -%d+%d  -%d-%d  +%d-%d\n",
> 	 rx, ry, xright, ry, xright, ybelow, rx, ybelow);
> 
>   XFree(vinfo);
> 
>   /*
>    * compute geometry string that would recreate window
>    */
>   printf("  -geometry ");
> 
>   /* compute size in appropriate units */
>   status = XGetWMNormalHints(dpy, window, &hints, &longjunk);
>   if (status  &&  hints.flags & PResizeInc  &&
>               hints.width_inc != 0  &&  hints.height_inc != 0) {
>       if (hints.flags & (PBaseSize|PMinSize)) {
> 	  if (hints.flags & PBaseSize) {
> 	      win_attributes.width -= hints.base_width;
> 	      win_attributes.height -= hints.base_height;
> 	  } else {
> 	      /* ICCCM says MinSize is default for BaseSize */
> 	      win_attributes.width -= hints.min_width;
> 	      win_attributes.height -= hints.min_height;
> 	  }
>       }
>       printf("%dx%d", win_attributes.width/hints.width_inc,
> 	     win_attributes.height/hints.height_inc);
>   } else
>       printf("%dx%d", win_attributes.width, win_attributes.height);
> 
>   if (!(hints.flags&PWinGravity))
>       hints.win_gravity = NorthWestGravity; /* per ICCCM */
>   /* find our window manager frame, if any */
>   wmframe = window;
>   while (True) {
>       Window root, parent;
>       Window *childlist;
>       unsigned int ujunk;
> 
>       status = XQueryTree(dpy, wmframe, &root, &parent, &childlist, &ujunk);
>       if (parent == root || !parent || !status)
> 	  break;
>       wmframe = parent;
>       if (status && childlist)
> 	  XFree((char *)childlist);
>   }
>   if (wmframe != window) {
>       /* WM reparented, so find edges of the frame */
>       /* Only works for ICCCM-compliant WMs, and then only if the
>          window has corner gravity.  We would need to know the original width
> 	 of the window to correctly handle the other gravities. */
> 
>       XWindowAttributes frame_attr;
> 
>       if (!XGetWindowAttributes(dpy, wmframe, &frame_attr))
> 	  Fatal_Error("Can't get frame attributes.");
>       switch (hints.win_gravity) {
> 	case NorthWestGravity: case SouthWestGravity:
> 	case NorthEastGravity: case SouthEastGravity:
> 	case WestGravity:
> 	  rx = frame_attr.x;
>       }
>       switch (hints.win_gravity) {
> 	case NorthWestGravity: case SouthWestGravity:
> 	case NorthEastGravity: case SouthEastGravity:
> 	case EastGravity:
> 	  xright = dw - frame_attr.x - frame_attr.width -
> 	      2*frame_attr.border_width;
>       }
>       switch (hints.win_gravity) {
> 	case NorthWestGravity: case SouthWestGravity:
> 	case NorthEastGravity: case SouthEastGravity:
> 	case NorthGravity:
> 	  ry = frame_attr.y;
>       }
>       switch (hints.win_gravity) {
> 	case NorthWestGravity: case SouthWestGravity:
> 	case NorthEastGravity: case SouthEastGravity:
> 	case SouthGravity:
> 	  ybelow = dh - frame_attr.y - frame_attr.height -
> 	      2*frame_attr.border_width;
>       }
>   }
>   /* If edge gravity, offer a corner on that edge (because the application
>      programmer cares about that edge), otherwise offer upper left unless
>      some other corner is close to an edge of the screen.
>      (For corner gravity, assume gravity was set by XWMGeometry.
>      For CenterGravity, it doesn't matter.) */
>   if (hints.win_gravity == EastGravity  ||
>       (abs(xright) <= 100  &&  abs(xright) < abs(rx)
>         &&  hints.win_gravity != WestGravity))
>       showright = 1;
>   if (hints.win_gravity == SouthGravity  ||
>       (abs(ybelow) <= 100  &&  abs(ybelow) < abs(ry)
>         &&  hints.win_gravity != NorthGravity))
>       showbelow = 1;
>   
>   if (showright)
>       printf("-%d", xright);
>   else
>       printf("+%d", rx);
>   if (showbelow)
>       printf("-%d", ybelow);
>   else
>       printf("+%d", ry);
>   printf("\n");
> }
> 
> 
> /*
>  * Display bits info:
>  */
> static const binding _gravities[] = {
> 	{ UnmapGravity, "UnMapGravity" },      /* WARNING: both of these have*/
> 	{ ForgetGravity, "ForgetGravity" },    /* the same value - see code */
> 	{ NorthWestGravity, "NorthWestGravity" },
> 	{ NorthGravity, "NorthGravity" },
> 	{ NorthEastGravity, "NorthEastGravity" },
> 	{ WestGravity, "WestGravity" },
> 	{ CenterGravity, "CenterGravity" },
> 	{ EastGravity, "EastGravity" },
> 	{ SouthWestGravity, "SouthWestGravity" },
> 	{ SouthGravity, "SouthGravity" },
> 	{ SouthEastGravity, "SouthEastGravity" },
> 	{ StaticGravity, "StaticGravity" },
> 	{ 0, 0 } };
> 
> static const binding _backing_store_hint[] = {
> 	{ NotUseful, "NotUseful" },
> 	{ WhenMapped, "WhenMapped" },
> 	{ Always, "Always" },
> 	{ 0, 0 } };
> 
> static const binding _bool[] = {
> 	{ 0, "No" },
> 	{ 1, "Yes" },
> 	{ 0, 0 } };
> 
> static void
> Display_Bits_Info(Window window)
> {
>   XWindowAttributes win_attributes;
> 
>   if (!XGetWindowAttributes(dpy, window, &win_attributes))
>     Fatal_Error("Can't get window attributes.");
> 
>   printf("\n");
>   printf("  Bit gravity: %s\n",
> 	 Lookup(win_attributes.bit_gravity, _gravities+1));
>   printf("  Window gravity: %s\n",
> 	 Lookup(win_attributes.win_gravity, _gravities));
>   printf("  Backing-store hint: %s\n",
> 	 Lookup(win_attributes.backing_store, _backing_store_hint));
>   printf("  Backing-planes to be preserved: 0x%lx\n",
> 	 win_attributes.backing_planes);
>   printf("  Backing pixel: %ld\n", win_attributes.backing_pixel);
>   printf("  Save-unders: %s\n",
> 	 Lookup(win_attributes.save_under, _bool));
> }
> 
> 
> /*
>  * Routine to display all events in an event mask
>  */
> static const binding _event_mask_names[] = {
> 	{ KeyPressMask, "KeyPress" },
> 	{ KeyReleaseMask, "KeyRelease" },
> 	{ ButtonPressMask, "ButtonPress" },
> 	{ ButtonReleaseMask, "ButtonRelease" },
> 	{ EnterWindowMask, "EnterWindow" },
> 	{ LeaveWindowMask, "LeaveWindow" },
> 	{ PointerMotionMask, "PointerMotion" },
> 	{ PointerMotionHintMask, "PointerMotionHint" },
> 	{ Button1MotionMask, "Button1Motion" },
> 	{ Button2MotionMask, "Button2Motion" },
> 	{ Button3MotionMask, "Button3Motion" },
> 	{ Button4MotionMask, "Button4Motion" },
> 	{ Button5MotionMask, "Button5Motion" },
> 	{ ButtonMotionMask, "ButtonMotion" },
> 	{ KeymapStateMask, "KeymapState" },
> 	{ ExposureMask, "Exposure" },
> 	{ VisibilityChangeMask, "VisibilityChange" },
> 	{ StructureNotifyMask, "StructureNotify" },
> 	{ ResizeRedirectMask, "ResizeRedirect" },
> 	{ SubstructureNotifyMask, "SubstructureNotify" },
> 	{ SubstructureRedirectMask, "SubstructureRedirect" },
> 	{ FocusChangeMask, "FocusChange" },
> 	{ PropertyChangeMask, "PropertyChange" },
> 	{ ColormapChangeMask, "ColormapChange" },
> 	{ OwnerGrabButtonMask, "OwnerGrabButton" },
> 	{ 0, 0 } };
> 
> static void
> Display_Event_Mask(long mask)
> {
>   long bit, bit_mask;
> 
>   for (bit=0, bit_mask=1; bit<sizeof(long)*8; bit++, bit_mask <<= 1)
>     if (mask & bit_mask)
>       printf("      %s\n",
> 	     LookupL(bit_mask, _event_mask_names));
> }
> 
> 
> /*
>  * Display info on events
>  */
> static void
> Display_Events_Info(Window window)
> {
>   XWindowAttributes win_attributes;
> 
>   if (!XGetWindowAttributes(dpy, window, &win_attributes))
>     Fatal_Error("Can't get window attributes.");
> 
>   printf("\n");
>   printf("  Someone wants these events:\n");
>   Display_Event_Mask(win_attributes.all_event_masks);
> 
>   printf("  Do not propagate these events:\n");
>   Display_Event_Mask(win_attributes.do_not_propagate_mask);
> 
>   printf("  Override redirection?: %s\n",
> 	 Lookup(win_attributes.override_redirect, _bool));
> }
> 
> 
>   /* left out visual stuff */
>   /* left out colormap */
>   /* left out map_installed */
> 
> 
> /*
>  * Display root, parent, and (recursively) children information
>  * recurse - true to show children information
>  */
> static void
> Display_Tree_Info(Window window, int recurse)
> {
>     display_tree_info_1(window, recurse, 0);
> }
> 
> /*
>  * level - recursion level
>  */
> static void
> display_tree_info_1(Window window, int recurse, int level)
> {
>   int i, j;
>   int rel_x, rel_y, abs_x, abs_y;
>   unsigned int width, height, border, depth;
>   Window root_win, parent_win;
>   unsigned int num_children;
>   Window *child_list;
>   XClassHint classhint;
> 
>   if (!XQueryTree(dpy, window, &root_win, &parent_win, &child_list,
> 		  &num_children))
>     Fatal_Error("Can't query window tree.");
> 
>   if (level == 0) {
>     printf("\n");
>     printf("  Root window id: ");
>     Display_Window_Id(root_win, True);
>     printf("  Parent window id: ");
>     Display_Window_Id(parent_win, True);
>   }
> 
>   if (level == 0  ||  num_children > 0) {
>     printf("     ");
>     for (j=0; j<level; j++) printf("   ");
>     printf("%d child%s%s\n", num_children, num_children == 1 ? "" : "ren",
> 	   num_children ? ":" : ".");
>   }
> 
>   for (i = (int)num_children - 1; i >= 0; i--) {
>     printf("     ");
>     for (j=0; j<level; j++) printf("   ");
>     Display_Window_Id(child_list[i], False);
>     printf(": (");
>     if(XGetClassHint(dpy, child_list[i], &classhint)) {
> 	if(classhint.res_name) {
> 	    printf("\"%s\" ", classhint.res_name);
> 	    XFree(classhint.res_name);
> 	} else
> 	    printf("(none) ");
> 	if(classhint.res_class) {
> 	    printf("\"%s\") ", classhint.res_class);
> 	    XFree(classhint.res_class);
> 	} else
> 	    printf("(none)) ");
>     } else
> 	printf(") ");
> 
>     if (XGetGeometry(dpy, child_list[i], &root_win,
> 		     &rel_x, &rel_y, &width, &height, &border, &depth)) {
> 	Window child;
> 
> 	printf (" %ux%u+%d+%d", width, height, rel_x, rel_y);
> 	if (XTranslateCoordinates (dpy, child_list[i], root_win,
> 				   0 ,0, &abs_x, &abs_y, &child)) {
> 	    printf ("  +%d+%d", abs_x - border, abs_y - border);
> 	}
>     }
>     printf("\n");
>     
>     if (recurse)
> 	display_tree_info_1(child_list[i], 1, level+1);
>   }
> 
>   if (child_list) XFree((char *)child_list);
> }
> 
> 
> /*
>  * Display a set of size hints
>  */
> static void
> Display_Hints(XSizeHints *hints)
> {
> 	long flags;
> 
> 	flags = hints->flags;
> 	
> 	if (flags & USPosition)
> 	  printf("      User supplied location: %s, %s\n",
> 		 xscale(hints->x), yscale(hints->y));
> 
> 	if (flags & PPosition)
> 	  printf("      Program supplied location: %s, %s\n",
> 		 xscale(hints->x), yscale(hints->y));
> 
> 	if (flags & USSize) {
> 	  printf("      User supplied size: %s by %s\n",
> 		 xscale(hints->width), yscale(hints->height));
> 	}
> 
> 	if (flags & PSize)
> 	  printf("      Program supplied size: %s by %s\n",
> 		 xscale(hints->width), yscale(hints->height));
> 
> 	if (flags & PMinSize)
> 	  printf("      Program supplied minimum size: %s by %s\n",
> 		 xscale(hints->min_width), yscale(hints->min_height));
> 
> 	if (flags & PMaxSize)
> 	  printf("      Program supplied maximum size: %s by %s\n",
> 		 xscale(hints->max_width), yscale(hints->max_height));
> 
> 	if (flags & PBaseSize) {
> 	  printf("      Program supplied base size: %s by %s\n",
> 		 xscale(hints->base_width), yscale(hints->base_height));
> 	}
> 
> 	if (flags & PResizeInc) {
> 	  printf("      Program supplied x resize increment: %s\n",
> 		 xscale(hints->width_inc));
> 	  printf("      Program supplied y resize increment: %s\n",
> 		 yscale(hints->height_inc));
> 	  if (hints->width_inc != 0 && hints->height_inc != 0) {
> 	      if (flags & USSize)
> 		  printf("      User supplied size in resize increments:  %s by %s\n",
> 			 (xscale(hints->width / hints->width_inc)), 
> 			 (yscale(hints->height / hints->height_inc)));
> 	      if (flags & PSize)
> 		  printf("      Program supplied size in resize increments:  %s by %s\n",
> 			 (xscale(hints->width / hints->width_inc)), 
> 			 (yscale(hints->height / hints->height_inc)));
> 	      if (flags & PMinSize)
> 		  printf("      Program supplied minimum size in resize increments: %s by %s\n",
> 			 xscale(hints->min_width / hints->width_inc), yscale(hints->min_height / hints->height_inc));
> 	      if (flags & PBaseSize)
> 		  printf("      Program supplied base size in resize increments:  %s by %s\n",
> 			 (xscale(hints->base_width / hints->width_inc)), 
> 			 (yscale(hints->base_height / hints->height_inc)));
> 	  }
>         }
> 
> 	if (flags & PAspect) {
> 	  printf("      Program supplied min aspect ratio: %s/%s\n",
> 		 xscale(hints->min_aspect.x), yscale(hints->min_aspect.y));
> 	  printf("      Program supplied max aspect ratio: %s/%s\n",
> 		 xscale(hints->max_aspect.x), yscale(hints->max_aspect.y));
>         }
> 
> 	if (flags & PWinGravity) {
> 	  printf("      Program supplied window gravity: %s\n",
> 		 Lookup(hints->win_gravity, _gravities));
> 	}
> }
> 
> 
> /*
>  * Display Size Hints info
>  */
> static void
> Display_Size_Hints(Window window)
> {
> 	XSizeHints *hints = XAllocSizeHints();
> 	long supplied;
> 
> 	printf("\n");
> 	if (!XGetWMNormalHints(dpy, window, hints, &supplied))
> 	    printf("  No normal window size hints defined\n");
> 	else {
> 	    printf("  Normal window size hints:\n");
> 	    hints->flags &= supplied;
> 	    Display_Hints(hints);
> 	}
> 
> 	if (!XGetWMSizeHints(dpy, window, hints, &supplied, XA_WM_ZOOM_HINTS))
> 	    printf("  No zoom window size hints defined\n");
> 	else {
> 	    printf("  Zoom window size hints:\n");
> 	    hints->flags &= supplied;
> 	    Display_Hints(hints);
> 	}
> 	XFree((char *)hints);
> }
> 
> 
> static void
> Display_Window_Shape (Window window)
> {
>     Bool    ws, bs;
>     int	    xws, yws, xbs, ybs;
>     unsigned int wws, hws, wbs, hbs;
> 
>     if (!XShapeQueryExtension (dpy, &bs, &ws))
> 	return;
> 
>     printf("\n");
>     XShapeQueryExtents (dpy, window, &ws, &xws, &yws, &wws, &hws,
> 				     &bs, &xbs, &ybs, &wbs, &hbs);
>     if (!ws)
> 	  printf("  No window shape defined\n");
>     else {
> 	  printf("  Window shape extents:  %sx%s",
> 		 xscale(wws), yscale(hws));
> 	  printf("+%s+%s\n", xscale(xws), yscale(yws));
>     }
>     if (!bs)
> 	  printf("  No border shape defined\n");
>     else {
> 	  printf("  Border shape extents:  %sx%s",
> 		 xscale(wbs), yscale(hbs));
> 	  printf("+%s+%s\n", xscale(xbs), yscale(ybs));
>     }
> }
> 
> /*
>  * Display Window Manager Info
>  */
> static const binding _state_hints[] = {
> 	{ DontCareState, "Don't Care State" },
> 	{ NormalState, "Normal State" },
> 	{ ZoomState, "Zoomed State" },
> 	{ IconicState, "Iconic State" },
> 	{ InactiveState, "Inactive State" },
> 	{ 0, 0 } };
> 
> static void
> Display_WM_Info(Window window)
> {
>         XWMHints *wmhints;
> 	long flags;
> 
> 	wmhints = XGetWMHints(dpy, window);
> 	printf("\n");
> 	if (!wmhints) {
> 		printf("  No window manager hints defined\n");
> 		return;
> 	}
> 	flags = wmhints->flags;
> 
> 	printf("  Window manager hints:\n");
> 
> 	if (flags & InputHint)
> 	  printf("      Client accepts input or input focus: %s\n",
> 		 Lookup(wmhints->input, _bool));
> 
> 	if (flags & IconWindowHint) {
> 		printf("      Icon window id: ");
> 		Display_Window_Id(wmhints->icon_window, True);
> 	}
> 
> 	if (flags & IconPositionHint)
> 	  printf("      Initial icon position: %s, %s\n",
> 		 xscale(wmhints->icon_x), yscale(wmhints->icon_y));
> 
> 	if (flags & StateHint)
> 	  printf("      Initial state is %s\n",
> 		 Lookup(wmhints->initial_state, _state_hints));
> 
> 	XFree(wmhints);
> }



-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

--IS0zKkzwUGydFO0o
Content-Type: image/png
Content-Disposition: attachment; filename="capture-xwinsched.png"
Content-Transfer-Encoding: base64

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
5swZb2/vfv36bdq06Y8//ujSpUtUVNSECRPscs3i4+Nff/1149PXX389LCys1FVGYWFhPXr0
6NevX1BQUOfOnX19fW1+30gkEj8/v2HDhk2ePNn61966dat9+/bGp6aPTdWvX9/42N3dXavV
2vH4AQAAAAAAAMAaZpMZY5xkZSATHBxsfNyhQ4dbt26VWq49B6nxPJ+UlKQ2kZaWZsN+hg8f
bpwPKCIiwnSuImvK6t+//8mTJ3U63caNG8WbsoWHh2/cuFGj0dy6dcs00HmBFi5cuG3btlq1
ap04ceKNN95YtWqVbW8atVr95MmT6OjoadOmSaWlhICCIJS1CIqiKu74AQAAAAAAAKD87BXI
FGfP2KhFixbXrl0r/37q16+vVCovXrx45coVjuM6dOhQprLq1KkTGBi4cePGuLi4Xr16EUJ6
9ep18+bNiIiIrl27ymQyu5xso0aNLl68aHx68eLFJk2alLrKVPPmzSdMmLBhw4bjx48vW7as
It43jo6OOTk5xqd37941Pm7atOnly5eNT00fW6kSjh8AAAAAAAAASmVlIHPp0iXj4z///LNp
06alvsSesdHMmTMXLFgQHR1tMBi0Wu25c+feeecd23YlTowdERHx7rvv2lBW//79Fy9ePHLk
SIlEQgiRSqUjRoxYvHixcZhf+X344YczZ86MiYlhGCYmJmbmzJkffvhhqauMhg0bdvbsWa1W
W1BQcPbs2YCAgIp433Tr1m3BggVZWVkMw1y5cmXcuHHGVePGjZsxY0ZsbCzDMLGxseKkSNar
nOMHAAAAAAAAgFJZGcgUCSusmcZHasej7Ny584IFC77++uuYmBie54OCgsaPH2/brgYNGrRo
0SKKohYtWmRDWQMGDFi2bJlp5PTuu++uXbu2e/fu9jrZIUOGaLXacePGpaSk+Pv7T5o0afDg
waWuMho9evTy5cujo6MdHByCg4M3b95cEe+bZcuWzZgxo02bNgaDoUGDBh9//PFHH30krho4
cGBubm54eHh6erq/v//YsWPnzZtn/Z4r5/gBAAAAAAAAoFRWBjLjx48XwwpfX98pU6b069ev
1D2Xfic1+De4fv36Rx99dOHCBVQFAAAAAAAAwKun+M3WrXmJtNQtzC6voKTJwi3lCOItexs/
fvy0adMCAgLi4+OnTp1q84hCAAAAAAAAAKgglqMSUsFpifQFlv3Ci/uX69q16/Dhwx89euTt
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
V2ZnZ+v1+qNHj3788cfGVZMmTZoxY8a5c+cMBkNSUtKECRPE5TNnzlywYEF0dLTBYNBqtefO
nXvnnXfEVcOGDTt79qxWqy0oKDh79mxAQECpL/Hx8blw4YIgCLiWAAAAAAAAAAB2VN7eRuvX
r58xY8bq1asFQahfv/7cuXONydGbb77Jsuz8+fPv3r3r5eU1depUcXnnzp0XLFjw9ddfx8TE
8DwfFBQ0fvx4cdXo0aOXL18eHR3t4OAQHBy8efPmUl8yZ86cCRMmpKWlCYKAm6kBAAAAAAAA
ANhLKXdSe6nhTmoAAAAAAAAAALZRqVS4HxkAAAAAAAAAAJiB2AgAAAAAAAAAAMxAbAQAAAAA
AAAAAGYgNgIAAAAAAAAAADMQGwEAAAAAAAAAgBmIjQAAAAAAAAAAwAzERgAAAAAAAAAAYIb0
FT63ESNG4AIDAAAAAAAAAJRVZGQkebVjo4yMDFxmAAAAAAAAAADbVGBsVKNGDdTvSycyMrJq
9tKqsgeGo33lj/blqh+c17+zliIjI0NDQ02XqFQqXD4AAAAAMFKr1ba9sGJ7G6G/z0uqyl64
l+sdhaN9lY72VW3N0EqjlgAAAAAALJCiCgAAAF5JgiCgEgDg34yiKDSGAABiY2gz3EkNAAAA
AAAAAADMQGwEAAAAAAAAAABmIDYCAAAAAAAAAAAzSo+N/v7776lTp7Zp08bX17du3bq9evX6
+eefMUIYAAAAAAAAAODVVvqU2L179zY+zs/Pj4mJiYmJSU5Onj9/fplKMt4MWCqV+vn5vfPO
OxMnTpRIJLgGVZzpXZxlMpmfn99//vOfKVOmyOXyii7X8g0CLbyjjK81buPo6KhSqVq2bDls
2LAePXq8wDoswniO165dW79+/aVLl9LT0ymK8vf3b9eu3TvvvNO+ffvKPyPLdVs1q/306dMb
N278+++/8/LyPDw82rVrFxYW1qVLF2sO2Ob3ntkPRakvL1NZVefD/vKeV6V9lo1rJRKJl5dX
796958yZ4+zsbLqZRqNp1aoVRVHR0dFubm5lfRubbT0AAKAk+FM3AICxMbT57sCl9zYKDg7+
4Ycfbt68mZKS8v3334sLIyMjbShMrVar1erk5OQff/zx999//+6773D9Xgrq55KSkn7++efY
2NgZM2ZUnQOz/I4St0lISNizZ09ISMi8efM+/fTTF1WB4s+8Ik8JIT/++OP48eO7det24MCB
pKSk69evz5kzJz4+vn///i/qjCzUbRWs9m+//farr756//33L1269PDhw8jISIqi3n777Ypr
eWz7UFgIHV7qD3vVP69K+yyLj1NSUnbt2pWamjp9+vQie9i7d+8bb7zRs2fPffv22fA2Ll6i
hS8H+LEEAAAAAOVXemz0+++//+c//1GpVHK5vGvXrsbvozYXKZVKW7duvWbNmt9++w0X4OUi
l8ubNm26Zs2a/fv3V52jsuYdJZfLa9asOXTo0OPHj1+9enXXrl1V5/j//PPPLVu2REVFDRky
xNfXVyaTeXh49O3b98iRIx9//PGLPSMLdVt1qv3MmTNRUVEHDx4MDQ11d3eXyWQtW7bctGnT
559/XgktT/EPxavRB+RVPa/KIZFI6tWrt2LFiqioqCKrtm7d+t5777377rtbt2614W1cJjt3
7mzatKmDg0NwcPDVq1dNV23ZskWhUJguWb16da1atWiaNr0/a/GF27dvb9SokVwub9my5YkT
J3CtAQCtEwCggXrlG6gyTImt0WjGjRsnPh42bFg5C27QoEF6err4WKVS7d69u1evXrVr1/b2
9hYXRkREtGvXzs/Pr127dr/++qvpa6Oionr27Onv79+6dWvTfk9RUVHdu3cvvvzu3bvDhw8P
DAz09/cPCQkx/o23pOVgGUVRxtGFZq9dRkbGjBkzAgICmjRpMnPmTJ1OZ7pxjx49/P39AwMD
w8PDMzMzTX9NtW3b1s/Pr3379hEREeV5R1ng5OQ0ffr0Ij/YXqx169ZNmzZNqVQW/XDS9Lx5
86rCGVmo26pQ7Rs3bpw2bVqRRpwQMmnSJJsPuJwfCrOfDnG56jnjay18KExZaK9KavostJZV
57wsNAsv5JTtq8ifWBISErKzszt16tShQweNRnPnzh3b3sbWf+/Zvn17dnb222+/PXToUOPy
K1eurF27dsiQIcYlv/7669q1aw8dOsRxnPGYzS48dOjQ0aNHc3NzZ8+eXf5vAgDwr/1VhtYJ
ANBAvYKx0dOnT/v163f+/HlCSK9evebOnVvOghMSEry8vIxPV6xYsWjRooSEhLS0NPFqrVq1
at26dUlJSWvXrl2+fPnu3bvFLY8fPz5r1qy5c+cmJibu3r374sWL4vLTp09PnDhx2rRpiYmJ
W7ZsWbNmjfHPvGFhYSEhIbGxsYmJiUuWLDH+8byk5VAShmHi4uImTpzYq1evkq4dISQkJCQo
KCghIeHkyZMajWbRokXGjVevXr148eLExMTLly8rlcopU6aIyw8fPrx8+fIff/xRvOKrV68u
5zvKguDg4Js3b1adWo2Oju7UqVN59lDRZ2ShbqtCtUdHRwcHB9v9fVKeD4XZT0eRYU2lfiiK
KKm9stD0ldRaVqnzsrBlJZ+yHXEcd//+/cmTJ3fr1s10udjVSPzT08iRI7dt22bb29hKO3bs
aNasmZOT09ixY1NSUsSFaWlp48aN2759u2mQt2rVqqVLlzZr1sz0b2VmF/7yyy/iH9AkEomf
n5+4cNu2bQ0bNpTJZLVr1964cSP+rQQAtE4AgAbqVWqgrI2NPvnkk7i4OPGb7ubNm8szHTLL
srGxsZ988olp0rZq1aq2bdvKZDLx6fr165csWRIUFCSXy9u0abNkyZL169eLq5YvX75kyZIu
XbrI5fI6deoYp1tavnz5ihUr+vTpI5fLmzRpsm7dum+++UZclZyc3KdPH6VSKZfLW7du/fPP
P1teDkUY+xH4+fl17do1Li7OtBdMkWtHCLl27drQoUMdHBx8fHyWLFly4MAB46r169e3a9dO
LpdXq1btiy++OHv2rPF345IlS1q3bi2Xy4OCgpYsWVLOd5QFbm5uGo2m6lRvTk5O8Zlxi/fd
eCFnZKFuq0615+XlFa/A8r9PyvOhsPDpKK6kD0URJbVXFpq+klrLKnVeFrasnFOuiNbSx8en
Q4cOsbGxy5YtM82S9u/fb3z7DR06dP/+/RzHWfk2VhVj/VGtWLFi4MCBhJDCwsLhw4evWbOm
Zs2aycnJxg1u3rx56tQpZ2fnRo0aXbp0ycJCQghFUQqFYuzYscbOXGPHjt2wYYNWq/3jjz9M
twQAQOsEAGigXoEGSmrldn/88Yf44Ouvv6Zp2rbCxK+5YsY2bNiwyZMnG1c1b97cdMv4+PjX
X3/d+PT1118PCwszXonOnTsX3/m1a9c++OCDf0Riz48zLCysR48e/fr1CwoK6ty5s6+vr+Xl
UISxBwHHcQ8fPvzyyy8XLly4Zs0as9fu6dOnX3755enTp9VqtfiLyPQNU79+feNjd3d3rVYr
Pr5165bpX9o7dOhQzneU5ZjG1dW16lSvm5tbTk5O9erVi9e5lb8MK+KMLNRtVat2V1fXvLw8
T09P+75PyvOhKKllM6ukD0URJbVXFpq+klrLKnVeFrasnFOuiNayoKDg3LlzkyZNOnz48MiR
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
zw0+dyrPeBMbAYT567hOAAgZG+3PIrV33nmnZs2abdu2jcVi11xzzaWXXpo6d8CAAddcc00s
Fhs3btwFF1yQnP799983a9Zs8+bNySknnXTSihUrYik/Q61SpUpubm779u1r1679wx/+sF+/
fuvXr0/OymSZeDxetWrV5MLTpk3LycmpWbNmTk7O73//e2OuEqpWrVr16tWTT3/3u9+l/iy5
Zs2a27ZtSz6dP3/+wIEDU18+cODAV199NfH4X//6V/v27VPndujQYe7cuYnHtWvXLrr1Qw45
5OBpbXn55JNPvvzyyx49eiSnlK21wf1TEYKPVywW27Bhwy233DJt2rSir33wwQdvvvnm4voz
eO6+OS7FKVXbSnWMwqw5eMwEzw0+dyrPeAOgzBSpAYS3P2OjOXPm9OvXL/F40qRJ69ate+ih
hxJPp0yZ8sUXX0yaNCkWi1188cV5eXnff/99YtbMmTM3btz4xBNPJJ6uXbu2oKCgY8eOhVZ+
3333TZo06bvvvvv000/r1at31VVXFW1Accuk/nE7Fos9+eST995776xZszZv3vzkk0+OHTs2
NzfX0Kk84vH4mjVrrrrqqiFDhhS3zIQJEy677LLk03/84x/HHnts6gKtW7f+9NNPE4+bN2+e
n5+fOjc/P3/16tWJx8OHD+/fv/+KFSt27NixY8eO5cuXX3LJJSNHjjxoW1tmM2bMuPzyy1Ov
58rW2uD+2QcKHa9YLParX/1q5MiRLVu2LLrwihUrtm3b1q1btzp16tStW7dr164vvPBChnP3
zXHJzs6uXr16dnb2hRdeuGzZstK2rQzHKJM1F9eq4DETPDf43Km04w0AAPalKolvIMkf2pSj
Ro0aBS9w1FFHzZkz58QTT0w8LSgo6Nq169NPPx2LxQYMGLBkyZLs7OzErA4dOtxwww0DBgxI
3D7jt7/97ZgxYz788MNYLDZ58uSPPvookTclfiWUePDRRx8lr+y/+eab5A+UMlkmdbFYLHby
ySfffffd5557buLpvHnz7rrrrrffftvoqRQj+H9DhzZt2ixZsqRevXpFl8nNzf3d7363dOnS
rKysxJRq1art2rWratX/i0337NlTq1at3bt3J+KM3/72t1OmTDn99NNjsdgbb7wxYsSItWvX
7tq1KxaL7d69+4ILLpg3b17ytb169Xr55ZerVat2ELY29Uwp1dw9e/a0bNly2bJlTZo0SU4s
W2uD+6eiFT1eCxYsuOOOO5YtW5ZodqFOqF69esuWLR988MHk8Ro+fPivf/3r//iP/yhxbubH
pcwuuOCC0aNHd+zYcdu2bQsXLrz++usnT558/vnnZ9i24o578DEqcc0BrQoeM8Fzg8+dyjne
AhT6HM/Ly3tz8GCfEcBBblo8fnXF/+CowU0lLDDumLLUyg29/GD8qVRwZ5aqJ+ND/q0Dq8yo
8IrFQltMc22cWRuC11OqHUmuqrx2v2jbyrbmg3N471+nzZrVs2fPvLy8nj17ZrJ8Ysm8vLzB
gwfvt18bvfvuu7FYLJkZxWKx7Ozsp59+esCAAYMHD37mmWeSmVEsFrv44ov/8Ic/JJreuHHj
iy666LDDDlu0aFEsFnv55ZcvvPDCoutv3br1/737NGiwZcuWsi0Ti8U+/PDDM844I/n0jDPO
eP/99w27SiIej+/Zs2fVqlXNmzcfMWJE2m/1d95557x585Lf6mOxWN26dQsd7i1bttStWzfx
eMiQIePGjbv77rt/9KMfNWzYcOzYsb/5zW8aNGiQmDt69Ohvv/126dKlyZvsbtq06cYbbzwI
WxvG/Pnz27Vrl5oZlbm1wf1T0ZlR0eM1cuTIRx55pLioq06dOrNmzTr33HPr1KlTp06dXr16
5ebm/va3v81k7j44Li+99FL37t1r1apVv379iy++ePbs2bfcckvmbSvbMSpxzQGtCh4zwXOD
z51KON4AKK2rFakBhLbfYqPUCrWkFStW1KtXb8eOHWvXrk2d3q9fv1dffXXr1q2TJk0aPnx4
LBYbPnx4or7svffe+8lPflJ0/ZlUMqt2jsggrlr1mGOOefzxx1988cVCs37/+9/fcccdixYt
atasWer0Vq1affzxx6lTVq1alZOTk3x60UUXLVmyZMuWLVu3bv3zn/9cp06dTp06JWbNnDlz
zpw5Xbp0SfxL7y5dusyZMyfxD7MOqtaGNGPGjCuvvLLQxLK1tsT+qSDFHa/Vq1e3a9cu9V/F
p/7P+KOOOqro/XT++c9/ZjJ3HxyXQjp16pQsv8qwbWU4RqVdc2qrgsdMiSMq4NypbOMNAAD2
zzfu/bXh5557rlBs9N577911113PPvvsM888c/XVV//jH/9IzsrJyTn66KMnTZr0/vvvJ27/
1TYWAAAgAElEQVSPfcEFF7z77rtTp07t0aNHjRo1KrSpxx9//OLFi5NPFy9enLiNN5XKzp07
a9asmTpl4sSJ991335/+9KfmzZsXWvicc84pdIOq3Nzcc845J+2ad+/efd999yXvh1K06ip5
G6yDp7UhbdiwYeXKlb179y7atjK0tlT9U14Cjldx/wUsMbd3795F76fTokWLTOZW9HEpKj8/
/8c//nEZ2laqY1TaNae2KnjMlGpEFTp3KtV4A6BspvlPagCh7dPYKPn39vfff3/nzp0dOnRI
ztqyZUv//v3vv//+Vq1anXLKKXfeeWe/fv22b9+eXKBfv36333770KFDE6Uf1atXv/LKK2+/
/fa+fftWdLNHjRo1fPjwFStW7Nq1a8WKFcOHD7/22msNnf2ub9++b7311tatW3fu3PnOO+8M
GjRo6NChybljx459+OGH33jjjeTXy1TXXnvtM8888+CDD3777bfffvvtgw8++OyzzyYPa+/e
vV9//fWtW7du3br1rbfe6tmz55lnnpksAR08ePDFF1+8fPnyxE12ly5d2q9fv8El3UMkSq0N
b/bs2QMHDiz6n7PK1trg/qkIwcerxNbecMMN8+fPT5RNvfrqq5deeumtt96aydyKPi6xWOy8
887705/+tGXLlu3bt+fl5Q0cOPCmm27KpG1hjlGJaw5oVfCYCZ4bfO5UnvEGQJkpUgMohyQn
tg9viZ28T+qYMWO2b98+bty45Kyf//zn1apVe+yxx5JTBg4ceMghhzz66KOJp3//+9/btm27
du3aww47LDHlyy+/POaYYz7//PMf/OAHhdZf9IasRWcFLFN07tSpU//rv/7rX//6V/PmzW+6
6aZy/6pGGcybN2/8+PHLly+vUqVK69athwwZMmLEiGQ0mbYC8Ztvvqlfv37i8ccff3z99de/
9dZbsVjstNNOmzBhQvJeV6+88sp99933l7/8pU6dOieffPLIkSMTN99N2L1797hx42bNmpX4
QVyrVq0GDx584403Bv/78Ci1Nm2bi55NAXPbt28/Z86cVq1aFdpu2Vob3D8V8r5Z0vEq7o0l
Yc2aNTfccMOiRYu2bdt2/PHH33DDDZdeemkmczM5LuV1WlWtWrVdu3bXXnvtJZdckmHLg497
8DEKXnNAq4LHTPDc4HOn8oy3DLklNsD+4pbY+6wz3RI75pbYlFWYW2Lvn/+kdtxxxz3++OMd
O3Z08AAgvKKx0WCxEXDQi8fjbmYKEIvFZoWIjarvlxZ/9NFHDhsAAFBxZEYA4VXVBQAAAAAU
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
XivVylPt390s7S6U19b32asAAADgoLVnz56rr746Pz8/Fovl5+dfffXVyZSjkNIVqYVJjnbt
2jVt2rTbbrutzHt16623Tps2bffu3fulTwsKCgoKCtauXTtt2rSXX375v//7v4tbZvXq1c8/
/3yPHj3GjBnzq1/9KvOVp6qIXcjkwJV5F/YNIREAAACEdMstt8yfPz/5dP78+bfcckvaJUuI
jRplZzfKzu6RMqXMydEbb7xx5JFHHn/88WXeqxNOOKFp06Z//vOf92PPVq9evX379pMnT87N
zS1umZo1azZr1qx///4LFy7861//+oc//OGAG0D7ZRfKFpZVUMQGAAAAUTVu3LhCP14ZN25c
2iUz+rVRVnl8UV+wYEHv3r2TT7Ozs5977rmf/vSnTZs2bdWq1eWXX568CdPf//73Sy+9tFWr
Vk2bNu3Ro8eLL76YfNUFF1zw6quv7vf+Pfroo7/66qsSF6tTp84NN9zw1FNPlWET33zzzTHH
HPPNN98Umti6devExPnz55955plNmzZt37797NmzS+zYRNJX2iK4ortQ3HYDjtr8+fPPOuus
Qi9JtPOcc85p0aLF4YcfHvv3cr+ZM2d26tSpSZMmp5xyytNPP52cXnQXUvdl5syZHTt2bNKk
SceOHZ988slMBhsAAABQnBJio/UFBesLCl5IN6u0Pzj661//2rFjx9QpkyZN+t3vfvfZZ5+9
/fbbWVlZ1113XWL6kCFDevTo8e6773722Wfjxo176aWXki/p3LlzovRu/1q9evVhhx2WyZKd
O3f+4IMPyrCJBg0a9OnTJzX7iMViTzzxRO/evRs0aPCnP/3pP//zP0ePHv3ZZ5/NmjVr8uTJ
qb8uS9uxibCvDEVwqbsQsN3ijtrChQtvvvnmO+6447PPPnvuueeWLl2aXPP9999/9913r169
+ssvvyy00SlTpjz88MNr1qyZNm3ahAkT5s2bV+IuzJkz58EHH0y86qGHHpo4ceJzzz1X4mAD
AAAAilO1zK/s/b8lbBkuv3bt2h//+MepU6ZPn96xY8eaNWs2bNjw17/+9eLFi5NL9urVKysr
q2bNmu3bt58xY0byJS1btly7du1+7K/du3e/++67I0eOHDBgQCbL//CHP/z+++9LXCztLbGH
Dh362GOP7dq1K7HMrl27HnvssaFDh8ZisYkTJ95///29evWqWbPmcccd9/DDD997770ldmzZ
pO5CwHaLO2oTJ04cN27caaedVrNmzZYtW06ZMiW55gcffPCUU06pUaNG0Y2OGzeuffv2iVXd
d999kyZNKrGd06dPHzduXIcOHWrWrHnyySePGzdu+vTpFdQnAAAAcDCovs+2tHnz5nr16qVO
Oeqoo5KP69evv3Xr1sTjIUOG/PSnP+3Tp0+HDh26d+/euHHj5GJ169bNJIWpCIkop1q1ak2a
NBkwYMC1116byas2bdpUaK/TSvvzn9atW7dq1erll1++6KKLYrHYSy+9lJOT07p161gs9t57
7/3iF79IXbhq1aoldmzZpO5CwHaLO2offPBB9+7d0675hBNOKG6jnTt3Tj7u0qXLhx9+WGI7
V61a1bVr1+TTrl27DhkypIL6BAAAAA4GZY+N5sZi60tT6/SDH/xg27ZtP/jBD5JTqlSpknbJ
3/zmN/369XvrrbcWLVo0ZsyY4cOH/+d//mdi1pYtW7KysvZLT5Xtjk7Lly9v06ZNmTc6dOjQ
iRMnJmKj6dOnJ0ur9u7du2bNmrp166Z9VXEdWzapuxCw3YCjVpxq1arts8NXvn0CAAAAB5y8
vLzSvqSE2ChRg9Y3Fit6e6PSxijNmjVbs2ZN27ZtM1n4hBNOSPwUZe3atd27d08GEGvWrGnW
rNmBcjy2bt06fvz4DH+XlFbPnj1vv/32t99+Ox6Pf/PNNz179kxMb9eu3XvvvXfqqaeWam1V
qlSJx+OlClAK7ULwdtMetTZt2vz5z38+66yzStXU5cuXn3HGGYnHy5YtS/4DvoBdaN269dKl
S88888zE06VLlx533HHeFAAAACAWi33zzTfJL9rB3njjjeTjjO5tVKgqrLQ3w0446aSTli9f
nsmSAwYMWLx48datW7ds2bJ48eLUOyKtWLGiffv2lfxI7Ny5c926dc8+++xZZ53VsWPHvn37
lnlVVatWveKKK6ZOnTp16tQrrrgiWRF200033XXXXStXrty5c+fWrVvfeuutgQMHlri2I444
YsmSJfF4vMy7ELDd4o7aqFGjbrzxxrfeemvnzp1r1qwZPnx4Jjt+00035efn79q1Kz8//6ab
bkq+KmAXrrrqqkKvuuqqq7wvAAAAQJmV8GujRBnaopScKJEZlaFi65xzzpk0aVLijs7Brrzy
yokTJ65cubJWrVqdO3d+/PHHk7Nefvnlyvw/sBKdU7t27ezs7JNOOunuu+9O/vglkxemSvbw
oEGDJkyYEIvFHnjggeTc7t2733XXXffcc09+fv7evXs7dOgwbNiwErdy++23Dx8+/Msvv4zH
48UdweBdCNhucUft7LPP3r1795133vn3v//9sMMOu/766zPpkGHDhl1zzTXr1q1r3Ljxdddd
16dPnxJ34eKLL966dWviVU2bNh01alSiuA8AAAAomyqxWCwej69fv77EUKOgoKDMmVEsFtu1
a1eHDh1yc3PLfK+f999/f9CgQfn5+dWr/1valZeXN2jQoOBdqDwOrNbuF9nZ2WUbYwAAAEBa
zzzzTOZFav3798/Lyxs8eHBGRWqJ7/BhMqNYLFajRo1rrrlm7NixZd7De+6555prrimUGQEA
AABQETKNYMrl1x/Dhg3LpJaqOE899ZQDBgAAALBvVNUFVDYq1AAAAKAyEBsBAAAAkIbYCAAA
AIA0xEYAAAAApFFR/5UsLy9vX+7G7NmzD6BOP7BaCwAAABycKio2GjRokM4FAAAAqAwmT55c
hlcpUgMAAAAgDbERAAAAAGmIjQAAAABIQ2wEAAAAQBpiIwAAAADSEBsBAAAAkEZFxUa1atUq
NGXu3Llnn332oYceWrt27W7dur3yyiuZzH3zzTf79+/fqFGjWrVqtWnTZvLkyfF4PPNmrFu3
rmXLllWqVCk0fdWqVb17987KysrKyurTp88nn3ySnLVnz57x48e3bdu2du3atWvXbtu27fjx
4/fs2ZPhmsugXFZywG26xCZVwrYFyHCgBgybsp0gzz//fN++fRs2bFizZs1jjz123LhxRcdq
oe4tJHXu008/ffLJJ9euXbtBgwb9+vVbs2ZNuZxTwbtQtEn78d1j/PjxvXv3Tp3y9ttvH3/8
8ftgCO2zDVXat5HU9eTn5w8bNqx+/fpFV57JmE92ZiV/dw04a84999wJEyaUYbuV81Ov8rTq
iy++aNKkyapVq1Infvzxx0ccccTnn39e2U6uMvRb8DtqyGuqEt/nK+K1e/funTJlSufOnevV
q1ejRo0WLVr84he/WLJkSSwWu/TSSydNmlRo+QcffPDSSy8NfmHSggUL+vTp06hRoxo1ahx+
+OEXXXTRokWLknO/++67+vXrN2jQYNOmTZmc3aU9Ox599NGmTZtWq1atklynlfkYBTSyxI/4
Ei9LDj/88ELTy/xeVI6X7gfEdXLwcdnH18ABF3LBYyDtaDmgr3wqzwjcjy2p0E+T1CvqMBsq
WwNKHKXVqlVr0qTJo48+ekC+AcXj8YLydskll8RT3H777T/5yU/eeOONzZs3b968ecGCBeee
e24mc2OxWI8ePZYvX75z584PP/zw9NNP//Wvfx3PWJ8+fWbMmJHYx6Qvv/zy8MMPf+CBBzZt
2rRp06YHHnigcePG69evT8wdMWJEt27dli1btm3btm3bti1duvTUU08dMWJEJmsum3JZyQG3
6RKbVEFtq7jVZjJQixs2ZT5BzjvvvCeffHLdunW7du365JNPevXqNWrUqLLt/qOPPtqyZct5
8+Zt2bJly5Ytc+fO7dq168aNG8OfUyXuYKrp06fvr3ePnTt3Nm7c+N13302dOHr06DFjxuyD
k2WfbajSnlOp6znuuOPuvPPODz74oOjKMxnzlaEzS9x08FnzzjvvNGnSZNeuXaXdbuX81KtU
rXrqqae6dOmyZ8+exNPdu3d36tRpxowZlfDkKtv7bcA7aphrqlJttxxfO2zYsAsuuGDlypVb
t27dsWPHJ598MmXKlFNOOSUej2/cuPHoo4/+9NNPkwt/+umnRx99dOKTK+CFCXfccUf79u1f
eeWVjRs37ty58y9/+ctFF12U2tvTpk275JJLBg8e/PDDD2dydpf27DjiiCMWLly4d+/eynCd
FuYYZd7Ioh/xwa9t2rTpkiVLyuu9qBwv3Q+I6+SABcq3E0p8Ywm+kMu8MZXn2IVpyb7Zi6Jb
yWRK5X+3yeS1yYvAMBsK2fiAvt27d+/ChQsbN268HwfwpEmT3s/MpEmTCgoKZs2aVYGxUV5e
XrJleXl5nTp1Ku7yN3juzTffnPqBum7duuzs7MwvDc8666yiR+7mm28u9DVj1KhRt912W+Jx
VlbWF198kTr3888/z8rKymTNYqODNjbKZKAWN2zCnCCFfPXVV/Xq1Svb7ufk5Cxfvjx1ytKl
SxNvuyHPqVLtQpcuXfbXu8cf//jH008/vdDEli1b/u1vf9sHJ8s+29ABERtlvvK0Y74ydGaJ
mw4+a+Lx+KmnnrpgwYJSbbRyfupVwlYNGDBgwoQJicf33ntvr169KuGZVbZ+C35HDfobOYQA
ACAASURBVHNNVartluNr69Sp8/333xc3Ny8v7/TTT0/s1N69e0877bSFCxdm8sIFCxa0a9du
69athabfc889ycedO3d+7bXXFi9e3LFjx4qIjapUqRKcGe1LYY5R5jteaECW+NqiXVTms758
L90P9Ovk8u2E4DeWEi8CxUb7KzbaX71U0Z8myYvAMBsK+VYZ3Nt79uypWrWq2Oj/S3376NOn
zwsvvFBcu4PnFlJQUFDoqrE4X3/9dYsWLT777LOiR+7EE09csWJF6pQVK1a0b98+8bhRo0ZF
L1VT3/4C1hz+pProo4+OOuqohx56KPH0pZdeOvHEE2vWrNm8efNHHnkk9SWzZ8/u2LFj3bp1
E8MuMeWkk06qVatWvXr1LrroooKCguTyAetJ26SPPvro3HPPrVevXs2aNdu3b//000/H4/Fu
3boVOlLr169v0KDBhg0b0i6f3HSHDh1q1ar14x//OHXTX3755S9/+ctDDjkkOzt72LBhW7Zs
KcPHYXD/FO2Nor+zK9qZAbuZ+eEuOlADhk05niBff/31oYceWrbPqho1auzcuTN1yo4dOzp0
6BD+nMp8F1atWtWyZcv99e5x1VVXPfDAA6lTVq5cecwxxwSPnJNPPvmQQw6pW7dujx493n//
/Xnz5p166ql16tSpW7du3759k6dhLBabOnVqTk5OjRo1jjzyyEI/bchkQ6nne8AZFHDSFXe+
ZHL6B6y5bG8+8Xj8scceO/LII2vUqJGTkzN16tSyxUZFx3yyMyvnu2uGZ008Hr///vuHDRuW
+UdJ5fzUq5yt2rhxY05OzurVqz/66KPDDjts3bp1qXOnTp3aqlWrGjVqtGrVavr06QFjIx6P
T5s2rUWLFsHDuAzK3G/B76hlvqYqcbtXX331gAEDUuf279//6quvLm2bi2rWrNn8+fMDFhgx
YkTirfv+++8fOXJkhi/s06fPc889F7Dajz/++Kijjkr0XuvWrT/88MNyj40yWT71gyDgQyS8
MMc3w7alHZDBv4gp9GkYfNYHfNyU+MK0H5oBDojr5NQFMvnALS+F3lhKvFQLExuV44EI+K6R
9sqnxI+MTF5b6MqkOAEfNGmHfdGLyeIuL8twQZv59WRxR7ZCP01SLwLDbKi4w5fhx1mYHwMe
dLFRassaNWqUm5vbtWvXQw45pE6dOqeeeurzzz+f4dxCbrrppgwvoy+77LLk3xILHZisrKzv
vvsudcq3336b/Hv1XXfd1b179+XLl2/fvn379u3Lli3r2rXr3XffncmaQ8ZGr732WqtWrV5/
/fXE0/nz5zdo0OD555/fvn37e++9d/TRR7/44ovJlxx33HFLlixJfs+PxWInnHDCn//85x07
dhQUFAwZMuTCCy/MZD1pm9S6detJkyZ9++23O3bsWLFixc9+9rN4PP7qq6+edtppqYuNHTv2
iiuuKG75eDz+xz/+sWnTpgsXLty+ffvq1asvu+yy5GubNGny+OOPb9u2bd26dYMHD05e6mX+
cRi8X8X1Rtr0PbUzA3Yz88NddKAGDJtyOUH27t372Wef/exnP7v++uuDB1ujRo2qVavWqFGj
Cy64YOnSpclZRX9ttGzZstTfcZT5nMr8HL/ppptSz7V9/O5x0kknrVy5stBLkn9ASDty2rRp
89Zbb+3YsePrr7+++uqrDz300Hbt2r355pvbt29PTEmeC7FYrFWrVitWrNixY8fy5cuPPPLI
1KaWuKFC53vAGVTcSRdwvmRy+gesuWxvPs8//3yyQ5YtW9ayZcvSxkbFjfm0nVl53l0zPGvi
8fg777yTmtseoJ96lfazOPFWX7Q87YknnmjRosWyZct27NixdOnS5s2bz549u7ix8fTTT+fk
5CSG8YoVK1q1alVeF4Jl7rfgd9QyX1OVuN2dO3d269ZtypQpiaeTJ0/u3r17sqMyb3NRc+fO
bdiw4WmnnXbbbbc98cQTn3zySaEFtm7d2r59+1dffbVDhw6pvx4KfuGPfvSjQherhdx4443j
x49PPJ4wYcINN9xQvrHRzp07M/lrc+pFUcCHSEDgkvbrYvke3wzblnZABlyWFO3SgPMi+DMu
4IUBV6oBDojr5OQCGX7glnnwBL+xlHipFjwGgk+x8joQxQm48inxI6PE1xa6MilOwAdNqS5C
AqaU6oI28+vJ4sZMhX6apF4EhtlQcYcvw4+zEs+XqlWrFvprvdgoHo/Hq1WrlpOTk3rPlBYt
WsycOTOTualmz57dpk2bQoequEDhlFNO2b17d9ojV7Vq1eRNDRJ2795drVq1xONdu3b16tUr
9V2yV69eyVUFrzlMbPTYY4+deOKJqSX63bt3T31j/ctf/nLCCSckX/L2228XWslHH32U+qfU
unXrZrKetE2qXbt2ob++JnTo0OGdd95JdlTTpk0TN4IpbvkuXbq88sorJfbAd999d8QRR5T2
4zB4v4rrjbRvmoU6s7jdzFDRgRo8bMKfIMmx2qZNm2+//Tagbeeff37iM+Cbb7559tlnmzVr
9tJLL6X+JerVV1/dunXr1q1b582bd+SRR1avXj38OZXhOb579+5mzZoVGkj78t2jfv36GzZs
SJ2Sk5Pz17/+NWDkfPDBB6nDLBaLpf5FeuPGjT/4wQ+SC6cWHL366qudO3fOfEOFhmjAGVTc
SRdwvmR4+he35rK9+XTu3LlQh5QqNgoY80U7s1K9u2Z41iQuRIJ/PFj5P/Uq82fx2rVrO3fu
fPjhhxe6g1uHDh3mzZuXGj0k74ZTdGx07NgxteJmwYIF5XJVEKbfgt9Ry3ZNleF2v/rqq5yc
nJUrV65cuTInJ+err74qbZuLs3nz5hdffHHMmDGXXHLJj370o9NPP73Qfv3lL3+pUqVKodw/
+IXVq1cPqJrZvXt3ixYtkrerWL9+ffPmzUscb5kf/d27d8+cOfPoo48uVWwU8CESXpjjm0nb
ihuQAZclhbo0+LwIeDcOfmGGV6oH4nVycoEMP3DLRdE3lhIv1YLHQPApVl4HojgBVz4lfmQE
v7bolUlxAj5oSnUREhwbZX5Bm/n1ZHHDrEI/TVIvAsNsqLjDl+HHWYmn2NFHHz1z5szk+5LY
6P8yxaL3TPl/7L15QBNn/vg/IQdJOOS+ApJwCXhwSkFAoatVgapV69FVW91tXa1df/b4bNe2
bretbe3x3aVKa9lqParVFq1VjqJiFeVQAW8R8QAF5b6vBML8/pg6nU4yTyaThAb6fv2VzPE8
z7znfc17Zp7x9/dns5bqhvz8/O7du8dGFv7+/pcuXWI6c+gy4dq1a2NjYwsLC6nTcL788sts
WuZcNnrzzTcnTZpEG5VUKqV/9+7RjSkMw2h6Rnw0RKu+otvROqR169a5uLisWrVqx44d9+/f
J5dnZGQsWbKE+L1///64uDj09hKJhPruDNVKV6xYIZPJyA+IaA5Jp2zRx8UkDa1OkyZMpsNk
GS81FVWnQhpuIGq1mpjYn+WNMoL8/Pzg4GDqgRPPo0okktjY2G+++cbZ2dlwm2J5CJmZmSkp
KZp3JIbMe/D5fKomXLhwwc/PDx1uNdUMoXjU2+Dd3d0SiYR9RzQVRVgQk9Gh7YV6L1Ffc+bm
fCQSCU0g+j5tpFXnNYVpbt6VpdUQB0jWbYdp1DPnWDx//vy8vLxPPvnkxRdfpF2E0DRTLBYz
6YbmxkbJCgyRG9qjcsup2PdLZN6BgYHkBZteY2aDUqlcs2bN9OnT9c3RaTs6OTkhJkbNzMyk
vbywaNEi8hLC8LIR8bUdplv0+gYRo2DI+WUzNrRCMqUlVJGi7QLhjdE7MoU2NMMiTyY3YBlw
jVIz0nQsLFM1Jh1Am5ixTgQTiMxHZ8hA7Ks1M0HUKJlOn15JCLpsxD6hRXSKs3tazXTRhJYE
GtIR0+kz1tNGhw4dIr62BmWj35SNwsPDNedMEQqFbNYSpKen+/j4VFVVsY/HCH1Fv5RoZ2en
OZ+Cvb09m5Y5l432799vZ2eXlZVFcxNMsznq5Qv0aoektLT0o48+WrBggYODwwcffEAsHBwc
DAkJqa2txXE8NjZ2//796O2ZTC4xMfHvf/97RUVFb28vjuMqlUrre7Y63SgH+bARHeIw0TAp
KlptDDcQksbGRvYTVRBNiUQiprUHDx4kkzxDbIrlIcybN08zhx5K72FnZ0eNBOvXr3/99de5
GZ1eGT+HjhAWxGR0CHthaf46kye9nI/hZSOtOq8pTDP0rmysBtfzaSPzjHpmG4tzc3OJ8oFS
qRwzZgz1eVJ02Yh9Nm9gVsBZbmiPyi2nYt9vWlpaeHi4QqGgTSxiyNxGmnR2dlpaWnIo2VB3
TE5ORsxtRHxSjQb1pWMDy0YDAwNffvklm7dQuZWNOLxnZMj5ZTM2hEIi0hLqgNFHhPbGiB25
lY2GRZ7MrWzE+SU1JseiVx6LTk21jsEoJ2KIy0ZaMxMOZSNjJTPGynxYukTTRRNaEmhIR0yn
z1hzG0VERKSnp8PTRvSy0VtvvaU5ZwpZZkavxXH8//2//+fr61tdXW1IBkb9q3UK9PXr1xO/
R40aRUtVa2pq7OzsDEwRdA7v+PHjDg4O3377Lbk8Njb25MmThvsCvdrR5M6dO1KplPy7a9eu
9evXIz4OTd0+JiYmMzNTcxuhUEgEQoKjR49yCIfc5KP5VQ6tHek8TE3YKyqtRwMNhHZZ5ejo
yF73ioqKqFV5Kv39/Y899hjTh5z0sik2h9DU1OTt7a0p6qH0HqGhoWVlZeTfMWPGUF95YKM5
6JDM9Aw/h44QFsRkdAh7YWn+TC1zcz4GvqTGpPM0YZqzd0VbDZHacr6uNs+oZyajUiqVgYGB
pLEfOHAgPj6emsnl5OSQf7Ozs6kvqdGaioqKIr/bRbNEI6KX3NAe1ZCcSme/Fy9edHZ2vnXr
1rlz51xcXKgvX7AZMxPr1q2jJda3bt3S/HSx1scQEDvm5OSEhoZq/ZJaU1PTqFGjWltbqcvb
29vt7OyamppwI81t1Nvbi7hto1cQMQqGnF+dY0MoJDotYf8JefYxTvMlNa2hjVugNKs8eShf
UkM4Fr3yWHRqih62ISeCCZ2ZDyJkoPfVzEyYQAQahNprJpOI9NJYmQ/L82W6aEJLAg3piOn0
sQxnOk1MJBL19fXhvxPmWzZqbm6Oj4+nzpkil8vJSSjRa9977z1/f382jxGy19q6ujo3N7fU
1NS2tra2trbU1FR3d3dyzC+++GJsbGxRURExDWdBQUF0dPSaNWtMXTYiLhLc3Ny2bt1K/D1+
/HhkZGRhYWFfX19XV9fx48fJjwTrZd4s26H+njFjxtGjR7u6ujo7O9PT08eOHUutJkRGRj79
9NPvvPOOzu0PHz7s5eWVl5enVCqp04lFRERs2LChubm5p6fn8OHD7u7uHMIhN/l4enqeOHGC
6je1dqT1MBFD0ktRae0YYiBz5szJz8/v7u5WKpUlJSUJCQnUKjuu7attJ06c6Orq6u3tzc3N
VSgU//vf/4hVSUlJeXl5xJvn+fn5iYmJ//znP41iU+hDIEhNTdXa3VB6j+eff578ktrly5cV
CgV1LRvNQZeNiBkNVSoVMWNoRkYG544QFsRkdAh7oaGvOXNzPt9//z1VIOynxEbovKYwzcS7
agVtNYRRrFq1ilvEGcqoN+xGtXHjxsWLF1OXTJ48effu3eSVho+PT3FxMamZ1CmxaU3t27fP
39///PnzKpXq/Pnz/v7+TFHVkPxBL7mhPapOr4gYFbrfrq6uMWPGkLJKS0sLDQ0lr3t1jhld
HYiMjDx8+DARuU6fPh0REaH5jIBWHUDvuH79+oiIiMzMzLa2NuIMEg8ZpaamPvPMM5ojWbp0
KREjfq8vqWkNIsbCkPOrc2xMColOS/QqG7GPcbQdmUIbuvdhkSeTG7AMuJxBOxadSSBaB9Am
Y6wTwYTOzAcRMnTuS8tMmEAEGoTaayaTiPTSWJkPSxdnomiimQQa0hHT6WMTgnH4khrnshFR
0J03b96oUaNEIlFYWNjevXtZrtX6kCTtFhCHwEx8f9Ha2tra2jopKam8vJzqZTZu3BgUFCQS
iUQiUVBQ0MaNG5nukBi3bITjeGVlpa+v74cffkj8PXnyZGJiopWVlUQiSUhIIKue+r4vw6Yd
6u+srKwpU6YQX5tOTk6mfX/k888/F4lEdXV1bLY/cOAA8Y1GuVy+bds28jCnTZsmFostLS1D
QkJ27tzJIRxyk8/u3btlMhn1bVKmjjQPU99nepkUVbMdzgaSlZWVkJAgFoslEklYWNhnn32G
flCF3F4qlcbExFCf2j18+HBsbKxIJLKzs5s6dSrTfIQcbErnAeI4HhYWxjQv4JB5j8zMTPKh
g7feeov63RyWmoMuG33xxRe+vr4CgUChUJC2wK0jhAUxGR3CXmjoa87cnA+O41999RXiy+VM
z8YjdF5TmGbiXZlAW01cXBz18+HNzc16vbM2NFFv2I2qurrazs7u9u3b1IXE7WjyHVXSVGlf
U9Z6Trdu3ert7U2o8ZYtW8jnR9CSMZ3c0B4V7RV1jgrR77Jly5YvX07dePHixStWrGCzL7rf
goKC5cuXe3t7CwQCGxubmJiY7du3s5ESmx2zs7Nnzpzp6OgoEAhcXV3nzp17/Pjx0NBQ6r19
khMnToSGhjKJEbHcWGUjrUHEiHA+vzrHhgjxiLREr7IR+xinuaPW0IZWy2GRJ1M3QAdcwy9k
0OkWOpFD6wD63BnxRDChM/NhChls9qVlJkwwBRqE2msmk4j00liZD3sXZ4poopkEGtgRUzqt
MwSP1LLRL6rT2NiIGRVnZ2cMGKG8//775eXlu3fvhsMERhL9/f1yuTwrKys0NDQ4OHjHjh1R
UVHGapzH42lNrYze0R+ZkSTMCxcupKSkVFdXCwQCYsnmzZtv3ry5efNmsxonjIpKWVnZn//8
5/Lycp1jALmZvzSGAIFA0NfXR9o4tyACmKFaQgJpIvS1ghF5IqiBBjDbJBCtqwMDAxKJpL+/
//ca3pYtWxISEthsefLkyYULFx49enTJkiUCUDJALwoKClJTU8+dOweHCYwwhELhunXr1q9f
n52dff369aHpdMg6+iMwkoT5xhtvrFu3jno9uX379u3bt5vbOGFUS5cu3bBhg0KhuHr16gsv
vLBixQo2YwC5mb80hoDRo0fn5OSkpKQQ9/+BkWEOkECa+mocY364b6SeCKZAA5hhEqjTn+M4
npOTM3r06GEnYSgbAfpZgoeHx9dff+3t7Q2HCYw8Xn311VdffRXkAPzuZGdn05ZcuHDBDMcJ
o5o6dWpSUlJVVZVMJluxYsUrr7zCZgwgN/OXxhDw3nvvrV69es6cOWq1GpzeyDAHSCBNCvtH
jUbYiWAKNMBw1FKBQODh4bFp06bhd4GMwUtqgDkrKEPJFh7VBgAAPBgAAAAAUQaizHCXIZxH
YCiBl9SAEQi4SwAAwIMBAAAAAESZkSpDOI+A+WMBIgAAAAAAAAAAAAAAAAA0gbIRAAAAAAAA
AAAAAAAAoAUoGwEAAAAAAAAAAAAAAABagLIRAAAAAAAAAAAAAAAAoAUoGwEAAAAAAAAAAAAA
AABagLIRAAAAAAAAAAAAAAAAoAUoGwEAAAAAAAAAAAAAAABagLIRAAAAAAAAAAAAAAAAoAUo
GwEAAAAAAAAAAAAAAABagLIRAAAAAAAAAAAAAAAAoAVTlY3u3r1L/VtWVrZ69Wo7Ozsej6d1
+6ysrOnTpzs4OIjF4ri4uCNHjrBfi6CmpkahUGh2euPGjeTkZBsbGxsbm5SUlIqKCnKVWq3+
+OOPx48fLxaLxWLx+PHjP/74Y7VazbJlDhilkWHXtc4hmW5snFvOz89fuHChs7OzpaXluHHj
tmzZguM4e63jrOcHDx586qmnHB0dRSJRUFDQRx99pKmQtAOkQV27b9++yMhIsVhsb28/f/58
mqlyNhydB4judyhdxMcff5ycnExdcu7cubFjxw6Beg9ZR2brK6jtIE46G50nhWnmLhRhNTNn
zvz000859Gueoc18RvXgwQOZTHbjxg3qwvLycnd399raWnMzLg5y03TylpaW+oYqDhprun2Z
Ti65fHBwMC0tLTo62tbWVigUyuXy5557rqCggEkg1FyCQCAQeHl5vfTSS11dXWzGQwsTJMnJ
ybTR7ty5Mzo62tra2traOjo6eseOHVojspWVla+v78KFC3NyctAhW6eqb9u2zdPTk8/nm3/s
0Esl+Hy+TCbbtm0bXJ4BAACYIziONxib2NjYlpYW/BHBwcH/+te/rl69SnRH480330xMTDx5
8mRXV1dXV1dubu7MmTNZrkWTkpLy9ddf0zqtq6tzc3NLTU1ta2tra2tLTU318PBobGwk1q5Z
syYuLq6oqKi3t7e3t7ewsHDSpElr1qxh0zI3jNLIsOta55BMNzbOXWAYNnXq1OLiYpVKde3a
tSlTpvz73/9mqXWG6PmTTz65e/fumpqa/v7+ioqKpKSktWvXcjut27ZtUygU2dnZ3d3d3d3d
WVlZNFPlbDjoQ9DZ75C5CJVK5eHhcfHiRerCV199dcOGDUNgEUPWkdn6Cmo7iJPORufNQZg6
u0ZbTWlpqUwm6+/v17df8wxtZjWqb7/9NiYmRq1WE38HBgYee+yxr7/+2gyNi5u/pZKenr5g
wQJ9QxUHjTXdvkwnl1y+evXq2bNnl5SU9PT0KJXKioqKtLS0iRMn6rREctXAwMCNGzdmzZr1
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
bWtrKxQK5XL5c889V1BQgGHY4sWLN2/eTNv+s88+W7x4MXpHktzc3JSUFGdnZ6FQ6ObmNm/e
vOPHj5NrOzo67Ozs7O3t29ra2Fi3vtaxbds2T09PPp9vdCdjXNeH9ro6lQp96hGJB0snYJ7h
z+jRxxDrG6YgMgFN+Hy+TCbbtm0b1BeAEQuO4w3GBtdGSkrK119/TfTIfi3T9mzQ2mZdXZ2b
m1tqampbW1tbW1tqaqqHh0djYyOxds2aNXFxcUVFRb29vb29vYWFhZMmTVqzZo1ex6IXRmnk
9+16yNr5HWVl/qPCMGzq1KnFxcUqleratWtTpkz597//zd7Q3nzzzcTExJMnT3Z1dXV1deXm
5s6cOZPN2ieffHL37t01NTX9/f0VFRVJSUlr167lJq5t27YpFIrs7Ozu7u7u7u6srKzY2NiW
lhbD7ZpGenr6ggUL9D2JQ+DBVCqVh4fHxYsXqQtfffXVDRs2DIGmDVlHw8KVBQcH/+tf/7p6
9apm42x03hyEqbNrtNWUlpbKZLL+/v6REXnNalTffvttTEyMWq0m/g4MDDz22GNff/21GRqX
0f0ty1DFQWNNt+/q1atnz55dUlLS09OjVCorKirS0tImTpyI43hLS0tAQMCtW7fIjW/duhUQ
EEBELsSOBG+99VZ4ePiRI0daWlpUKtX58+fnzZtHlfaXX365YMGCJUuWfPHFF2ysW1/rcHd3
P3bs2ODgoNGdjHFdH9rropUKferRiQdLJ2Ce4c+4p8AQCzLKCH+XYIrIBDQZHBw8duyYh4cH
DgDmzebNm6+wY/PmzQ0NDd98882Qlo2+/fbbadOmMZk9Yi1nN8HU5uuvv05L8deuXfvGG28Q
v21sbB48eEBdW1tba2Njw/5YoGwEZaPfhddff52a+dXU1Li4uLA0iqNHjz722GNM14fotTTq
6+ttbW25icvPz6+4uJi6pLCwkLj2NtCuacTExBw9elSvkzg0HiwzM3PKlCm0hQqF4vLly0Og
aUPW0fByZTob16rz5iBMnV3rtJpJkybl5uaOgMhrhqNatGjRp59+Svz+8MMPk5KSzNCyTOFv
2YQqzhpron2lUmlnZyfT2qNHj06ZMoU4qMHBwcmTJx87dozNjrm5uSEhIT09PbTl77//Pvk7
Ojo6Ly/v1KlTUVFRpigb8Xg8zjWj3zE1onldtFKhTz068WDjBEZ8ZDTcgoZv2Ujf3tVqtYWF
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
9UottHo/9knFkL2kFhERkZ6eDk8bASOvbGSBmYaysrLRo0drtUba5RZ6LbpllvZPa3PGjBl7
9+6lbr93794ZM2aQ+yIuDvUdLUsWLFiQkZGxdOnSffv2kQuJl60MPxfc2gkPD3/ttdf2799f
UlLy7rvvEgtDQ0N//vlnY/UeEhJy+vRp8m9+fr7O1ng8nk5p83i8V155JS0traysrKqqau7c
uejt/fz8AgICCPuZPXs2hmGzZ8++ePHi1q1bp06dKhQKic3OnDmzadOmgIAAsViMYdjJkycN
OYNSqbS1tZX8W15eTl1LE0tISAhLaf/nP//ZtGnTzz//7O3trZdRJCcnl5WV0QxNLpezWUtD
pVKJRCJuvoLGwMDApk2bXnrpJcPtmqC5ubmkpCQ5OdlsPZhcLr916xb598CBA/Pnz9dL/9Ew
qRaHjhAWweQo9PJF5umC2Og8TZjm6eFZWs2tW7eYLH24RF7zHJVKpVq7du0HH3yAYZhIJHr/
/fdJR4dh2NixY0+dOkX+PXXq1Pjx45mamjBhQkFBAfmX+tsQTOpvEaHKQI29dOnS22+//d13
3+3fv3/lypW3b99mvy+Cl19+Wa1WU5fU19c7OjoauOOaNWvefffd3t5e2l4ffPBBc3Pz8ePH
W1tbaQ93nDhxorm52SinmM/nL1u27MqVK4bEDm7ulNu1PTrTQCiVXqdeM/HQ644RFUTAYpIn
OjlEY+pTYIgFMcV0zWQDkVpobqxX+DNc61hy5cqVZcuWkU9LAcCIwhRPGykUiv/9738c6rWa
a1NSUk6cONHV1dXb25ubm4tomWWbdXV1bm5uqampbW1tbW1tqamp7u7u5KyEL774YmxsbFFR
ETH7XUFBQXR09Jo1awysPbMZXmlpqZub29atW4m/x48fj4yMLCws7Ovr6+rqOn78OPmBXr3u
RbNsh/p7xowZR48e7erq6uzsTE9PHzt2LLH88OHDXl5eeXl5SqWSNr0fh96///57YiJPlUpV
XFzMZkpsT0/PEydOUF/W0LpLf39/ZGTk008//c4777A5Be+9955AIKDOcfjOO+8IhcLvv/+e
evdgw4YNzc3NPT09hw8fdnd317wBwv4MzpkzZ8WKFY2NjSqVqqCggMgYyNaoYvHx8cnIyGCj
cu+9956/vz/16V/2RtHc3BwfH099t18ul5OztKLXzpkzJz8/v7u7W6lUlpSUJCQkUB+1wLV9
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
iXpiKNuuk/AgJlEnwWPwzjvv9PX10bc0NDS4uLjoeWBiYuK2bdvY32TYvn17c3NzUVHR06dP
6R62ra3twoULzc3NhnrV9IoVK27fvq3rgTpZaXQqyoCSefv27RUrVlArbQEAAADARBhjtVFo
aGhiYiLlMpVK5YULF9rb27u6uvLz82Uy2TfffEMWzZ8/v7i4uKOjQ6VSVVVVzZgxg35f9NNP
P/Xz88N5mIKOPnU+fvzYzc0tJSWltbW1tbU1JSXF3d2depVjTEzM+fPnyZfsFBcXR0dHf/DB
B9Sxb731VkRERFlZGfn+y5KSEsY44NzdmjNnTkFBQXt7+/Pnz9PT0ydMmMB1h1Yul1dUVKjV
avIFwydOnCCLDh065OPjU15eThbJZDL8V2L/8MMP9GrxX4mt00wx6mlubo6MjKS/40MqlR44
cACnFD3X7LYQooieXPQpoMWGJCUlRWOFWsXGZOrzxhtvpKSkkL9/+uknmUxGL/Xy8rpw4QL9
YRNdVxtplFh+DSkUiq1btzY3N3d2dp45c8bd3Z3a58yZM6NGjTp//rxKpaK/uLqoqGjy5Mml
paXd3d3t7e1FRUUxMTEax4FLB7lqRpw1olG0riHOHTHp7MHENy887CEp1dT7brRaCbO1zEOs
z/RStki0t7ePGTOGcgppaWlBQUHkqj3qpKytrelvbv6f//kfoVD4ww8/IJYUGWS1EcJ56bMU
SKub0LMJ3rYd0RxaeNCTqFVt0UtmJk+efObMGdLjXLlyRaFQsJclapxT9IGbN29WKBTZ2dmt
ra1qtbqyspJcZJSSkrJ06VJ2T5YvX076I4EhXomNvz9+RKQ/+JKpz4kDAAAAgP6rjYyVNvrs
s8/orz/MycmZMWOGWCy2tbUNCws7fvw4u0gikQQHB+/atYtxuciGcVeKjZ511tTUzJ07d9iw
YcOGDYuJibl37x5VdObMmYiICJFI5OjoOHPmTMabiXt6ej777LNx48aJRCKRSDRu3DjGOOAE
ATk5OVFRUTY2Ng4ODrGxsfTPkTBC7a+//trX19fa2lomk+3bt49eIVXk6+ubnp6OjvUZIci3
334rlUqFQqFcLt+zZw9m2kinmWLX8/Dhw7i4uOHDh4tEouDg4MzMTMxS9Fyz20KIInpytZ4C
QmxIgoOD6+rq2FVpFRuTqU92dnZkZCT5+6OPPqJ/y4YgiMOHD3t6etJfqaBr2kijxPJr6MGD
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
M9iAW1xcjKcVZDLZxIkTyd9PRKeNFM1KF2kjTeRGEBMTQ5dBUHfgxLxeutiqydpGlpaWlHmg
GIY9efIEESl6enrMzMyYp41wzp49q/hIBnHW8PCwn59ffX29v78/MZeK2Dtv3jy6tY3mz5+P
aNuJEyfmzJnDYigyNDR04MABJm+2KtVk1q4MY/WSmloDAwI/P7/09HSYbQQAAGBQaaMxHN3A
5XIRe69cuTJhwgSGRf3nP//Zu3fvTz/95OrqyvAUxE0dh8OZP3/+sWPHyMcfO3Zs/vz5xLmI
ec7oklmzbNmyEydOxMbG5ubmEhvxN8I0vxbsyvH19X3//fePHz9eX1+/c+dOfKORkdF7772X
mpp65cqV+/fvL1myBH28RCL56aefFAv/+eef9+7d6+npyePxOBzO+fPntd6v69evf/LJJ99/
//3x48fj4+N/++03xWOMjIzUvXYIbUTrRlRU1JUrVyhWIBQKmeylIJfL0fbF3NyGhob27t27
ceNGXRuOul3QnYsQCoV37twh/p48eXLp0qWaqASFixcvEr8rKyu9vb1ZV4QwEzrLUsvY1bJZ
dpbo7e1NEQg7qVIUhiJMw3ShTKyGw+HcuXOHztJHS2gzzFbJ5fJNmzbt2bMHH5B89tlnhKPj
cDhTpky5cOEC8ffChQvTpk2jK2r69OlVVVXEX/JvTdBEbjidnZ319fVRUVFaGTgxrBcRW5m0
mY6AgAD8JVYyRUVFM2bMwH+/++67w8PD5L1tbW12dnbqij06OtrMzIy5RY8ZM2bbtm1///vf
t23bNmYMdcwcHx//r3/9C88kEvT29u7cuTM+Pp6uzN7e3k8//fTNN99koTbGxsZr1qy5efOm
dl0Zk5DELgfKfGBAcPPmzTVr1hDTbAEAAABDQRezjciPgjEMi46OrqiokEql/f39xcXFIpFI
6SRhxbC0a9cuDw8P8jsU7J7pkf8+fvzYwcEhKSmpu7u7u7s7KSnJ0dGR+GjOO++8ExISUlNT
gy/gV1VVFRgYmJiYyPr5DPPmNTQ0ODg4pKWl4X/Lysr8/f2rq6sHBgakUmlZWRnx/WC1HpUz
LIf8e/78+SUlJVKptKenJz09fcqUKcSuwcFBf3//11577V//+pfK48+cOePi4lJeXi6TycjL
6/r5+e3YsaOzs7Ovr+/MmTOOjo4sZhsh+iWVSidOnEgscZqamiqRSPApG+SSnZ2dKyoq6N5M
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
SwaxVVtbm4+PT1lZma+vLzGXimgdNWoU07uNRo8ejRjb0aNHQ0NDOaQira2te/fuZfNkq1JN
5uzKMH19SM3HxycpKQlmGwEAAGi7bGQo0AlfffXV1q1bz5075+TkRGkKDw+vqKggL6moqJBI
JPjv0aNHHzlyhNx65MiR0aNHo3eHuKhT2SfG/MJalT1zZvLkyUePHp0xY0ZaWhqxEH8ijL/w
ufXj7e29YsWK9PT0srKyDRs24AsNDAyWLVuWmJhYUVFx7969iRMnotf39PQ8d+4cvfNffvll
69atbm5uIpFIIBCcP39e48d17dq1L7744ocffkhPT58/f/6ff/5JX8fAwEDdc4fQZLRuoPUc
3UpBoVAIhUL2Y66oqOjVq5fSptbW1q1bty5evFjbhoNTU1NTVlYWHh7egS5CIpHcvn2b+Hvs
2LFJkybxUQkKFy9eJH4XFBR4eHhw3hHCTJgsSy1jV8tmuVmih4cHRSDcpErReYow9dOFstTP
27dvM1l6Zwlt+jkqhUKxZMmSzZs3CwQCoVC4adMmwtEJBIJ+/fpduHCB+HvhwoUBAwYwdTVw
4MDCwkLiL/k3H/jIjY9H5amxiNjKLWHD8fPzwx9iJZOdnf3OO+/gvz/55JO2tjZya3V1tbW1
tbpij4iIMDU1ZW/RhoaGsbGxI0eOjI2NNTSk5szz589fv349XkkkaGho2LBhw/z585n6bGho
+PLLL+fMmcNBbYyMjGbOnHn9+nXNujI2IYlbRUnbXL9+febMmcScXAAAAECLaHu2UVxcnKur
K/k5CDI1NTXBwcHkl61IJBLi7ZWPHz+2s7OLj4+vq6urq6uLj4/v0aMH+pXbKu9aoPtctGhR
YGBgcXEx/obOwsJCf3//mJgYnvdD2AyvvLzczs5uz549+N+zZ8/6+voWFRU1NzfX19efPXuW
+H6wWrfKWfZD/j169Ojc3Nz6+vpXr14lJSX169ePaGppafH19X3//ffXr1+vcv2TJ0/27Nkz
Ly9PLpeTX6/r4+Ozbt26mpqaxsbGkydP9ujRg8NsI8Rx1dfX9+7dm3jFaWJioqenJz5lg9yz
o6Njfn4+05MpdNCajD4jaD1Ht44fP76goKChoUEul5eVlYWEhJCnWmDKvtqWn59fX1/f1NSU
k5MjlUqJOflhYWF5eXn4S4IKCgqGDRv22Wef6cxw4uPjle5Oly5i7ty5xJfUfv31V6lUSm6l
q4S6s43wV+cqFAr8ldhHjx7lvCOEmTBZFsIoKKhrs9w8zI8//kgWCPtXYiN0ni5MPXGhSlGp
n/Hx8fgjMBzCii5DW6cb1caNG6dNm0ZeMmTIEOKT5wcPHnR2di4pKSE0k/xKbEpXaWlprq6u
paWlCoWitLTU1dVVwPrjm1qSGx+Pih4Ver/o2KpyzIj9FhQU2NraHjhw4MmTJ62trU+ePNm/
f7+trW1BQQGxra+v78mTJ/HQdvHiRR8fH2KaJPvZRhiGbdmyJTY2VlNzYf75z396e3vn5OTU
19c3NDScOXPG29t77ty59JXlcvm9e/dSUlLc3d2Jz89h2vySGvusSWk6pFUE8CU1AACATjXb
SBdlI6W1qufPnxMr3LlzJzIy8q233hIKhV5eXsTT4zj4h6K7du3atWvXsLCwmzdv8g9OiD5b
Wlo2btzYp08foVAoFAr79OmzceNGpa881HjZCMOwqqoqFxeXLVu24H/Pnz8/bNiwLl26iMXi
kJCQjIwMDtc8LPsh/87MzBw6dCj+Ierw8HDKJ0t2794tFAofP37MZv1jx47hX3uVSCT79u0j
DnPEiBEikcjU1NTDwyMlJYVD2QhxXDNnzpw9ezZ5zWnTpkVHR1N6PnTokIODA+WpeHT2idZk
9BlB6zmiNTMzMyQkRCQSicViLy+vnTt3oktdxPpmZmYBAQHkZwlPnjwZGBgoFAotLCxCQ0OJ
V2XrxnC8vLzIbyzuEBeRkZERHByM/167du2KFSvIrXSVULds9M0337i4uBgbG0ulUkLhue0I
YSZMloUwCgrq2iw3D4Nh2HfffYf4cjnT3WyEztOFqSculAm0fgYFBZE/K15TU6PWM2u6CW2d
blT379+3sLD4888/yQvLy8sdHByIZ1QJU3VxcUlKSkKHgD179jg5OeFqvGvXLuKxX7RktCc3
Ph5V5agQ+0XHVvS2KvdbXFz83nvvWVtbGxkZWVtbv/fee8XFxURrYWHh7NmznZycjI2Nzc3N
AwIC8I+aIQ6ZSbB//fUX+WYY/6JGcnKyn5+fmZmZmZmZn58f2SGTxyYWi6VS6eTJk7Ozs1We
L22UjRCuTGk6pL2CEXranVqPv0HZCAAAQDdlo/9GiKdPn2p2BpONjQ1M43pd2bRp082bNw8d
OgSiADodLS0tEokkMzPT09Ozb9++Bw4c8PPz01TnTPP8Nb6jN5nXSZhXrlyJiIi4f/++sbEx
viQhIeGPP/5ISEjQq3HCqMhUVFR88MEHN2/eVDkGkJv+S6OTYmxs3NzcTPiNN5bW1laxWNzS
0gIqAQAAwJ5du3aFhISwWfP8+fNTpkzJzc2NiooyBMEBalFYWBgfHx8XFweiADojJiYmS5cu
jY2NFQgEN27c0E31QWc7ehN4nYS5evXqpUuXkq/9kpOTo6Oj9W2cMKoZM2ZUVVW1trZevXp1
3rx5xH7RYwC56b80Oim9evXCpyy9yULAMCw7O5vp1Y0AAACAZjEGEQDsMTAwsLe3379/v7pv
2QQA/WH58uXLly8HOQAdTlZWFmXJlStX9HCcMKrQ0NCwsLB79+45ODhER0cvW7aMzRhAbvov
jU5KXFzcwoULx48fT8J83WIAACAASURBVHlN+Jt1AWNsbG9vv3XrVtAHAAAAXXhdEAHAHt3f
2sKftNeHkQCAHhoIoA+Am3rtmTVr1qxZs0AOYLl6wvTp06dPn/6Gn743uWQGAACge6BsBMB1
OAAAALgpAADLBQAAAABACfBuIwAAAAAAAAAAAAAAAEAJUDYCAAAAAAAAAAAAAAAAlABlIwAA
AAAAAAAAAAAAAEAJUDYCAAAAAAAAAAAAAAAAlABlIwAAAAAAAAAAAAAAAEAJUDYCAAAAAAAA
AAAAAAAAlABlIwAAAAAAAAAAAAAAAEAJUDYCAAAAAAAAAAAAAAAAlABlIwAAAAAAAAAAAAAA
AEAJUDYCAAAAAAAAAAAAAAAAlKCtstH27dvb2tqIvxUVFQsXLrSwsDAwMKCvjGg1oGFqasp+
GA8fPpRKpfRub926FR4ebm5ubm5uHhERUVlZSTS1tbVt3759wIABIpFIJBINGDCAcizonjmg
kU463a5VDkkPx4agoKBgypQpNjY2pqam/fv337VrF4Zh7BVSIBBkZmaOGjXKyspKJBIFBQWd
OnWKTevx48cnTJhgbW0tFAr79Omzbds2uq6iDYrcmpaW5uvrKxKJLC0tJ02adPfuXR3YlEqL
06X32L59e3h4OHnJ5cuX+/XrpwMV0tmO9NaNkPtBnFY2Ok8IU8+9K8JqxowZs2PHDg771c+o
pz+j+vvvvx0cHG7dukVeePPmzR49ejx69EjfjIuD3NB+j2Wo4qCx2tu2vb09MTHR39+/W7du
JiYmEonkH//4R2FhoUAgmDZtWkJCAmX9nTt3Tps2Db0hQU5OTkREhI2NjYmJiZ2dXWRk5Nmz
Z4nWly9fWlhYWFpa1tXVsbFuda1j3759jo6ORkZGepKn8Tm/aWlpdnZ2RF6h1l9uhsA/79Ln
eKpywIgVNH6w6DSMZ35L911vTtqjSwtVuS05C+WzI85jUKkARkZGDg4O+/btg/JNR4Jh2BNN
M3jw4JiYGOx/9O3b9/PPP//tt9/w3VFAt5JJSkqaPHkyxpqIiIj9+/dTun38+LGdnV18fHxd
XV1dXV18fLy9vf3Tp0/x1piYmKCgoOLi4qampqampqKiIsqxIHrmhkY66XS7VjkkLY1Ne92G
hoaWlJQoFIrff/996NChX375JUuFxDBszZo1w4YNO3/+fH19fX19fU5OzpgxY9i0vvfee4cO
HXr48GFLS0tlZWVYWNiSJUu4Hf6+ffukUmlWVlZDQ0NDQ0NmZmZgYGBtba22bUqlxenMeygU
Cnt7+6tXr5IXLl++fN26dTowFp3tSG9titwP4rSy0Xl9EKbKXaOtpry83MHBoaWlRd396mfU
06tRff/99wEBAW1tbfjf1tbWQYMG7d+/Xw+Ni4Pc0H6PZajioLHa23bhwoXjxo0rKytrbGyU
y+WVlZWJiYnvvPMOhmG1tbVubm63b98mVr59+7abmxseuRAb4qxdu9bb2/vUqVO1tbUKhaK0
tDQyMpIs7b17906ePDkqKuqbb75hY93qWkePHj3OnDnT3t6uD3kan3OEYZijo2NhYSG3v9wM
gWfepefxVOWAESto/GDZJFrc8ls9vyTpqEuVDvHAROLE0xXwHD9CpO3t7WfOnLG3t8cA3iQk
JFxnR0JCwpMnTw4fPqzFstGjR4/Mzc3VdQoqzS8gICA3N5d9ajhixAh6t59++inlMmPJkiWr
V6/Gf5ubm//999/kVvqxMPUMZaM3tmz06aefkjO/hw8f2traslTI3NzcQYMGMV0folspVFdX
d+vWjdvhy2SykpIS8pKioiI8hGjVpthYnG68R0ZGxtChQykLpVLpr7/+qgNj0dmOOkXZiH3n
SnVeH4Spctdoq8EwbPDgwTk5OWrtVD+jnh6OaurUqTt27MB/b9myJSwsTA8ti5vc0H6PTaji
rLFa2tbMzOzVq1dMrbm5uUOHDsUPqr29fciQIWfOnGGzYU5OjoeHR2NjI2X5pk2biN/+/v55
eXkXLlzw8/PTRtnIwMAAXTPSJXzOEf1Y1PrL2RA4512vdz1CewfL1DO3/Lbzlo20OmamPrXt
gYnEiacr4Olh0CJta2szNDSEos9rWDZSmovwufC7deuWVCplGWmePXsmkUju3LlD79bT0/PS
pUvkJZcuXfL29sZ/29jY0FNV8rEgeubvIG7cuOHq6rp79278788//+zp6SkUCp2cnL777jvy
JqmpqX5+fl26dMHtB1/i5eVlamrarVu3yMjIJ0+eEOsj+lE6pBs3bowZM6Zbt25CodDb2zst
LQ3DsKCgoJ9++om82tOnTy0tLWtqapSuT+zax8fH1NS0V69e5F0/fvx4wYIFYrHY1tZ24cKF
DQ0NHEImWj50adDn2dGFiThM9qf7yZMnlMsbhNpERERQ9si+la72VlZW3EzMxMREoVCQl8jl
ch8fH23blEqL05n3mDdvXnx8PHlJWVlZ79690Zrj6+srFou7dOkSGhp6/fr1rKyswYMHm5mZ
denSZcKECYQZCgSCPXv2yGQyExMTZ2dnytQGNjsi2zvCghBGx2QvbMwf0TM354NhWHJysrOz
s4mJiUwm27NnD7eyEV3nCWHqp3dlaTUYhn399dcLFy5kH0r0M+rp56hqa2tlMllVVdWNGzfe
fvvthw8fklv37Nnj4uJiYmLi4uKSlJSE0A0Mw/bu3SuRSNBqzAHOclPL79FDFWeNnT9//tSp
U8mtU6ZMmT9/vrpjptOzZ8/Tp08jVoiJicFd99dff7148WKWG0ZERBw7dgzR7c2bN11dXXHp
ubu7//777xovG7FZnxwIEEGEP3zOLyVsqfUXHSbYm7laeReaTpEDk1dgE0y1V9HgnN+q7FyD
J4LO1q1bx44dS/x9+fKlo6MjudDs6emJ30xVmhUwJWxK9bmmpsba2rqmpoY8gJqamu7du1MW
Ik69Vj0wOXHisyOEObOMAnzm2QGdtWwUGBi4YcMGzV74rVq1SmmfSpkxYwZxL5HSrbm5+cuX
L8lLXrx4Qdyv/uKLL4KDg0tKSpqbm5ubm4uLiynHguiZpxfOy8tzcXHJz8/H/54+fdrS0vL4
8ePNzc3Xrl1zc3M7ceIEsUnfvn0LCwuJ63yBQDBw4MBffvlFLpc/efJk9uzZ48ePZ9OP0iG5
u7snJCS8ePFCLpdfunRp4sSJGIZlZ2cPGTKEvNrGjRvnzJnDtD6GYRkZGY6OjmfOnGlubq6q
qpoxYwaxrYODw4EDB5qamh4+fBgVFUWkeuxDJvq4mKRB75YiTMRhsj/dq1atolzvIdTGxsbm
yJEjgYGBYrHYzMxs8ODBx48fZ9lK0N7efufOnYkTJy5btgytbDY2NkZGRjY2NuPGjSsqKiKa
6LONiouLyfM4tGRTKi1OZ97Dy8urrKyMshVxJ0Sp5vTv3//ixYtyufzZs2fz58+3srLy8PAo
KChobm7GlxC2IBAIXFxcLl26JJfLS0pKnJ2dyedR5Y4o9o6wICajQ9gLG/NH9MzN+Rw/fpwQ
SHFxsVQqVbdsxKTzSoWpP96VpdVgGFZeXk6u23bSqKe3sRh39fTH0w4ePCiRSIqLi+VyeVFR
kZOTU2pqKpNupKWlyWQyXI0vXbrk4uKiqYyWs9zU8nv0UMVZYxUKRVBQUGJiIv53165dwcHB
hKDYj5lOZmamtbX1kCFDVq9effDgwcrKSsoKjY2N3t7e2dnZPj4+5NlD6A27d+9Orv/SWbly
5fbt2/HfO3bsWLFihWbLRgqFgs1tc3JShAgi9K0QL6bQ+PmlHzv7v+jYxN7M1cq70HSKHJhY
gWUw5awYKjWcc36rsnNNnQil3LlzRyQSETqfkJBgZmZGaPj9+/ft7e3xqrHSrIBpzEz6PHfu
3M2bN5PX3LRp09y5c9m7Ea16YHLixGdHCHNmGQVUqqKhoSHlJjfQ6ctGYWFhra2tGrzwa21t
7dmzJ+WWIKKg8M477xADoHRraGhIvNSA6NzIyAj/3dLSEhYWRvak5GNB98ynbJScnOzp6Ul+
RD84OJjsXktLSwcOHEhscvnyZUonN27cIN9K7dKlC5t+lA5JJBIpFbWPj095eTkhKEdHR/xF
MEzrBwQEnDp1SqUEXr582aNHD3VDJvq4mKSh9JqcIkymw2RJampq//79yc4RrTZGRkYymYz8
UiGJRJKSksKmlZIH9O/f/8WLF4ixjR07Fi9qPH/+/IcffujZs+fPP/9MvluVnZ3d2NjY2NiY
lZXl7OxsbGysbZtCt+rSe1hYWFBu+8hksitXriA057fffiOrmUAgIN+Rrq2t7dq1K7Ey+YGj
7Oxsf39/9juiqCjCgpiMDmEvLM2fqWduzsff358iELXKRgidpwtTr7wrS6vBMyr05EH9j3r6
HIsfPHjg7+9vZ2dHeYObj49PVlYWufRAvA2Hrht+fn7kR8BycnI0khXwkRt7v0cPVTw1trq6
WiaTlZWVlZWVyWSy6upqdcfMRH19/YkTJ9atWzd58uTu3bsPHTqUclylpaUGBgaUuj96Q2Nj
Y8SzM62trRKJhHjvxtOnT52cnFTqG/uz39rampKS4ubmplbZCBFE+MPn/PIpGyG8KHszVzfv
QtMpcmBiBZbBVCMorZJwzm9Vdq6pE8GEt7f3999/j9+Fcnd3P3r0aN++fYmL6gULFiCyAqYx
M+nz9evXHR0diXqHQqFwcHC4fv06ezeiVQ9MTpz47AhhziyjgErtdXNzS0lJUXqZAHTWstHg
wYM/+eQTDV74ZWRkREREsJSFq6vrtWvXmLpF1zuXLFkSGBhYVFREfg0ncSzonjl74TVr1gwe
PJgyKjMzM+p37/53Y0ogEFAMBv9oiFJhovtROqSlS5fa2touWLDgwIEDf/31F7H86NGjUVFR
+O/09PSgoCD0+mKxmPzsDNnjREdHOzg4EB8QoQ9JpWzRx8UkDaXX5BRhMh0my5qRTCZ78OCB
WgpJf6mQq6srm1aCtrY2/AsF5NtZKikoKCBiJH7g+ANWYrE4MDDw8OHDNjY22rYpdKsuvYeR
kRFZE65cuSKTyRD9K1UzhOKRb4M3NDSIxWL2O6KoKMKCmIwObS/k+43qmjM35yMWiykCUXe2
kVKdpwtT37wrS6vBD5Co23bSqKfPsXjSpEl5eXn/+te/Fi1aRLlQoWimSCRi0g36yhrJCvjI
jaXfUxqqeGoshmH4VYS7uztxUafWmNkgl8tjYmJGjRql7sUGZcPu3bsjXvKakZFBeRBj6tSp
RAmAf9kI/2wQ05RPdYOIRuBzfvmUjRBelKWZc8i70HSKHJhYgWUw1VLZiE9+q7JzTZ0IJjZv
3hwZGYkXv4YPH45h2LBhw/CXo40YMYIoxinNCpjGjNDn4cOHE3NXDx8+jO+RnoYxzQLTngem
JE58doQ4fE3NNjpx4gT+tTUo/bw+ZaNHjx5ZWlpq8MIvMjKSTXxFmx/ein660sLCgv4+BeJY
+MztRIw2PT3dwsIiMzOTko8yvc1R6YUl0xK1+iEoLy/ftm3b5MmTraysiHmV7e3tHh4ejx49
wjAsMDAwPT0dvT5TyBw2bNhHH31UWVnZ1NSEF93pLlilVLnJh43oEIeJJikpydnZ+d69e2op
pLe3N/2lQiYmJmxaKTx9+pT9iyrwroRCIVPr8ePHiasO7dkUulWX3sPCwoIc0mJjYz/99FNu
RqdWxs9hRwgLYjI6hL2wNH9E2YiD8+FfNlKq83Rh6qF3ZWM1mJqzjfQz6ultLM7JycHLB3K5
vHfv3uT5pOiyEd2stHHBxkdubPweU6jiqbEYhiUmJnp7e0ulUsrLR/i824jOq1evTE1NOZRs
yBuGh4cj3m2Ef1KNAvmhY55lo9bW1r1797J5CpVb2YjDs0h8zi+fshHai6o8BG55F7cgqFc5
MLeykcYfUuOT37IxH42cCCaqqqrMzMwaGhoIb3D06NGxY8e+ePHC1taW/kgam2sKhD6fOHGC
mLvq6+tLTPZn6Ua054EpiROfHSEOX1PvNvLx8UlKSoLZRq9V2ejhw4cWFhaauvB79uyZk5MT
h08RK+1W6bvcY2Nj8d9vvfUWJVVlOhZMow+pnT171srKCp8tiRMYGHj+/Hn+FzZq9UPnzp07
ZmZmxN+DBw/GxsYiPg5NXj8gICAjI4O+jomJCR4scXJzczmETG7yoX+/Q+mOVB4mnX//+98u
Li73799XVyHXrl1Lf6kQcTcG3Urh0aNH1tbW7HWvuLiYfIeBTEtLy6BBg5g+5KRBm2Jvcdr2
Hp6enhUVFcTf3r17kx95YKM56NyC6fkCDjtCWBCT0SHshaX5M/XMzfnwfEiNSecpwtRn74q2
Gjz95XxdrZ9RT09GJZfL3d3dCWM/duxYcHAwOSXNzs4m/mZlZZEfUqN05efnR3y3i2KJGkQt
uan0e+xDlboae/XqVRsbm9u3b1++fNnW1pb8WCibMTOxdOlSyhXC7du36d9gVjpVAbFhdna2
p6en0i+pPXv27K233nr+/Dl5+YsXLywsLJ49e4Zp6N1GTU1NiNs2agURjcDn/PIpG7GPTXTx
cs67uAVBvcqB9eQhNT75rVqd8zkR6MRvy5YtvXr1wn1FS0tLr169tm7dOn36dG7XFAh9bmtr
k0qlv/zyy8WLF52dnSlPbKmUg/Y8MCVx4rMjxOGzjAIqdUwoFDY3N0Pd57UqG/n7+8fExGjq
wi8+Pv6zzz7TlJt7/PixnZ1dfHx8XV1dXV1dfHx8jx49iDcjLlq0KDAwsLi4GH8NZ2FhIdOx
YJp+JXZ5ebmdnd2ePXvwv2fPnvX19S0qKmpubq6vrz979izxkWC1LmxY9kP+PXr06Nzc3Pr6
+levXiUlJfXr149cTfD19X3//ffXr1+vcv2TJ0/27NkzLy9PLpeTXwfo4+Ozbt26mpqaxsbG
kydP9ujRg0PI5CYfR0fH/Px8spdXuiOlh4kYUlxcnKurK5s5sfR+ampqgoODyS8VkkgkxFta
0a3jx48vKChoaGiQy+VlZWUhISHkOwaYsq9a5Ofn19fXNzU15eTkSKXSb7/9Fm8KCwvLy8vD
nz8vKCgYNmwYwug0aFPsLU7b3mPu3LnEl9R+/fVXqVRKbmWjOeiyEf7qXIVCgb/N9OjRo5x3
hLAgJqND2AsFdc2Zm/P58ccfyQJh/0pshM7Thakn3lUpaKvBVZd4t4K6EUeXUa/TjWrjxo3T
pk0jLxkyZMihQ4eIqxFnZ+eSkhJCM8mvxKZ0lZaW5urqWlpaqlAoSktLXV1dmaIqn/xBLbmh
/Z7KUIUYFXq/9fX1vXv3JmSVmJjo6elJXBurHDN6foSvr+/JkyfxyHXx4kUfHx/6PAKlOoDe
MDY21sfHJyMjo66uDj+D+CSj+Ph48kUjwYwZM/AY0VFfUlMaRDQFn/PLp2zEPjZROuGTd6GF
3ylyYGIFlsG0Q8pG6AxWZeeaOhEI4uLijI2NyZ8OWL9+vYmJyY8//shGeegJG1qfd+zYERkZ
OXHixH//+9/qCllLHpieOPHZEeLw2UQuDL6k9maWjTZu3Eip/qInQ6Jbvby8KLc1eLo5/BuN
Xbt27dq1a1hY2M2bN8meaOPGjX369BEKhUKhsE+fPvRj0VLZCMOwqqoqFxeXLVu24H/Pnz8/
bNiwLl26iMXikJAQ4q6Fus/LsOmH/DszM3Po0KH416bDw8Mp3x/ZvXu3UCh8/Pgxm/WPHTuG
f4hRIpHs27ePOMwRI0aIRCJTU1MPD4+UlBQOIZObfA4dOuTg4EB+LJZpR/TDVHfeL+VeJaKf
O3fuREZGvvXWW0Kh0MvL68iRIyxbMzMzQ0JCRCKRWCz28vLauXMneqIKsb6ZmVlAQAB5Zu/J
kycDAwOFQqGFhUVoaCjT7FmN2xQbi9ON98jIyCAmHaxdu5b83RyWmoMuG33zzTcuLi7GxsZS
qZSwBW47QlgQk9Eh7IWCuubMzflgGPbdd98hvlzOdFoROk8Xpp54VyYQVoNhWFBQEPnz4TU1
NWo9s6abqNfpRnX//n0LC4s///yTvBC/ZU08o0qYqouLS1JSEjoE7Nmzx8nJCVfjXbt2EfNH
0JLRntzQfg8dqlSOCrHfmTNnzp49m7zytGnToqOj2WyL3m9hYeHs2bOdnJyMjY3Nzc0DAgKS
k5PZSInNhllZWWPGjLG2tjY2Nn777bcnTpx49uxZT09P8iQygvz8fE9PTyYxIpZrqmykNIho
ED7nl3PZiH1sQscItfIutMp1ihyYvAI6mGqqYMRGq9XNb9HbavBEMFFZWUnp5D//+U+3bt3I
T1qpdU2B1ue6urq33nrrrbfeqqur4+AWtOGB6YkTzx0hDl9l5IKykZ6Xjf6r6E+fPhVoFBsb
GwHwmrJp06abN28eOnQIDhN4nWhpaZFIJJmZmZ6enn379j1w4ICfn5+mOjcwMFCa5mp8R28y
r5Mwr1y5EhERcf/+fWNjY3xJQkLCH3/8kZCQoFfjhFGRqaio+OCDD27evKlyDCA3/ZeGDjA2
Nm5ubiZsnFsQAXSscpAcagl1NRxOxGuZOKHVoLW1VSwWt7S0wInjya5du0JCQtisef78+SlT
puTm5kZFRRmD4AC1KCwsjI+Pv3z5Mhwm8JphYmKydOnS2NjYrKysGzdu6GanOtvRm8DrJMzV
q1cvXbqUfD2ZnJycnJysb+OEUc2YMWPdunVSqfS3336bN29edHQ0mzGA3PRfGjqgV69e2dnZ
ERER+GwFQP9VDpJDbZcMBMwT9+BEvN6Jk0o3iGFYdnZ2r1694Kx1FFA2AtQzaXt7+/379zs5
OcFhAq8fy5cvX758OcgB6HCysrIoS65cuaKH44RRhYaGhoWF3bt3z8HBITo6etmyZWzGAHLT
f2nogLi4uIULF44fP76trQ2cnv6rHCSHWoX9VCM4EW+mAhgbG9vb22/duhVk1VFA2QjQik/X
FEy1Z62OBOaBA6BUQOf1YIAumTVr1qxZs0AOAAemT58+ffp0CCIQxyGCaO9EgAxfG6C83uFA
2QiAIA0AAAAeDAAAAIAIAjIEAEAJhiACAAAAAAAAAAAAAAAAgA6UjQAAAAAAAAAAAAAAAAAl
QNkIAAAAAAAAAAAAAAAAUAKUjQAAAAAAAAAAAAAAAAAlQNkIAAAAAAAAAAAAAAAAUAKUjQAA
AAAAAAAAAAAAAAAlQNkIAAAAAAAAAAAAAAAAUAKUjQAAAAAAAAAAAAAAAAAlQNkIAAAAAAAA
AAAAAAAAUAKUjQAAAAAAAAAAAAAAAAAlaKtshGEY+e+tW7fCw8PNzc3Nzc0jIiIqKyuJpra2
tu3btw8YMEAkEolEogEDBmzfvr2trQ1vLSgomDJlio2Njampaf/+/Xft2kXpGc3Dhw+lUqmB
gQFlOefxqOyZAxrppGN3rW/9dFIx8oSlsSBUNzMzc9SoUVZWViKRKCgo6NSpU2xajx8/PmHC
BGtra6FQ2KdPn23bttHthSIuCuTWtLQ0X19fkUhkaWk5adKku3fvasSu0T2rFJ0uPdj27dvD
w8PJSy5fvtyvXz8dqJDOdtQpXFlFRcXChQstLCzonbPReUKYeu7hEbo9ZsyYHTt2cNivfkZe
/RnV33//7eDgcOvWLfLCmzdv9ujR49GjR/pmXBzkRnfypqam6oYqDhqrvW3b29sTExP9/f27
detmYmIikUj+8Y9/FBYWCgSCadOmJSQkUNbfuXPntGnT0BsS5OTkRERE2NjYmJiY2NnZRUZG
nj17lmh9+fKlhYWFpaVlXV0dG+tW1zr27dvn6OhoZGSkcSejWdeH9rp8gjg6PWDpBPQz/Gk8
+vCxvk4KIhOgY2Rk5ODgsG/fPqgvAK8tGIY90TRffvkl9j8eP35sZ2cXHx9fV1dXV1cXHx9v
b2//9OlTvDUmJiYoKKi4uLipqampqamoqGjw4MExMTF4q0AgCA0NLSkpUSgUv//++9ChQ8k9
qyQiImL//v34MWpkPOieuaGRTjp21zrrpwNlpf+jYmksTKq7Zs2aYcOGnT9/vr6+vr6+Picn
Z8yYMWxa33vvvUOHDj18+LClpaWysjIsLGzJkiXcxLVv3z6pVJqVldXQ0NDQ0JCZmRkYGFhb
W8vfrtE9o0WnSw+mUCjs7e2vXr1KXrh8+fJ169bpQNN0tqNO4cr69u37+eef//bbb/TO2ei8
PghT5a7Rul1eXu7g4NDS0qLufvUz8urVqL7//vuAgIC2tjb8b2tr66BBg/bv36+HxsVBbhSS
kpImT56sbqjioLHa23bhwoXjxo0rKytrbGyUy+WVlZWJiYnvvPMOhmG1tbVubm63b98mVr59
+7abmxseXxAb4qxdu9bb2/vUqVO1tbUKhaK0tDQyMpIs7b17906ePDkqKuqbb75hY93qWkeP
Hj3OnDnT3t6ucSejWdeH9rp8gjg6PWDpBPQz/Gn2FPCxII2MsEOCKSIToNPe3n7mzBl7e3sM
APSbhISE6+xISEh48uTJ4cOHtVg2srW1JUb26aefUlLqJUuWrF69Gv9tbm7+999/k1sfPXpk
bm5ObEsOZg8fPiT3rDItGzFiBN3R8BkPumcoG0HZqANhYyxMqpubmzto0CCm60N0K4Xq6upu
3bpxE5dMJispKSEvKSoqwq+9edo1ume06HTpwTIyMoYOHUpZKJVKf/31Vx1oms521LlcmcrO
leq8PghT5a7Ruo1h2ODBg3NyctTaqX5GXj0c1dSpU3fs2IH/3rJlS1hYmB5aFje5UQgICMjN
zVUrVHHWWC1ta2Zm9urVK6bW3NzcoUOH4gfV3t4+ZMiQM2fOsNkwJyfHw8OjsbGRsnzTpk3E
b39//7y8vAsXLvj5+WmjbGRgYMC5ZtSBqRHF6/IJ4uj0gI0TeO0jI38L6rxlI3X33tbWZmho
CFUJAMpGakB2qZ6enpcuXSKP9dKlS97e3vhvGxsbukdmyiEoPSN49uyZRCK5c+cO3dR5jgfR
M39PdOPGDVdX+daJWwAAIABJREFU1927d+N/f/75Z09PT6FQ6OTk9N1335E3SU1N9fPz69Kl
C+6e8CVeXl6mpqbdunWLjIx88uQJsT6iH6VDunHjxpgxY7p16yYUCr29vdPS0shd+fj4mJqa
9urVi+iK294xDEtOTnZ2djYxMZHJZHv27EHLkz5Lji6KoKCgn376ibzV06dPLS0ta2pqlPa5
devWsWPHEn9fvnzp6OhITvI8PT2JfOLx48cLFiwQi8W2trYLFy5saGjgcwaZ1EAgEOzZs0cm
k5mYmDg7O1PuP7NXObqxIFQ3IiKCIjf2rXTTs7Ky4hZ6TUxMFAoFeYlcLvfx8eFv1yp7RohO
lx5s3rx58fHx5CVlZWW9e/dG67+vr69YLO7SpUtoaOj169ezsrIGDx5sZmbWpUuXCRMmEMaI
Vi02OyL7HIRFMDkKtDfQWxek0ujoOk8IUz89PEvdxjDs66+/XrhwIftwpp+RVz9HVVtbK5PJ
qqqqbty48fbbbz98+JDcumfPHhcXFxMTExcXl6SkJIRuYBi2d+9eiUTCMpLqQG5kbt26JZVK
EYUJ9nmdyv3Onz9/6tSp5NYpU6bMnz9f3THT6dmz5+nTpxErxMTE4K7766+/Xrx4McsNIyIi
jh07huj25s2brq6uuPTc3d1///13jZeN2KyPiB3kzdXK6PgrJyLTUCuIo9MDtUI8HaaAxUae
LE+Qzk4BHwtSGtOVJhtMqQXTyiyTCl3W4DrdjTcAykYdXDYiJ5rm5uYvX74kj/XFixfEXYIv
vvgiODi4pKSkubm5ubm5uLg4MDBww4YNSg9y1apVLFPYGTNmEPfxKAbMczyInnl6ory8PBcX
l/z8fPzv6dOnLS0tjx8/3tzcfO3aNTc3txMnThCb9O3bt7CwkAh1AoFg4MCBv/zyi1wuf/Lk
yezZs8ePH8+mH6VDcnd3T0hIePHihVwuv3Tp0sSJE/HlGRkZjo6OZ86caW5urqqqmjFjBp+9
Hz9+3MXF5dKlS3K5vLi4WCqVcphtRBFFdnb2kCFDyCts3Lhxzpw5TB3euXNHJBIR+pCQkGBm
ZpaYmIj/vX//vr29PZHvOjg4HDhwoKmp6eHDh1FRUURqyO0MIspGhFhKSkqcnZ2PHz/OIRrR
jQWhujY2NkeOHAkMDBSLxWZmZoMHDybvFN1K0N7efufOnYkTJy5btgx9Em1sbIyMjGxsbMaN
G1dUVEQ00W/6FRcXk+8ocrZrlT0jRKdLD+bl5VVWVkbZhLibp1Rt+vfvf/HiRblc/uzZs/nz
51tZWXl4eBQUFDQ3N+NLCPtFq5bKHVF8DsIimBwFwiL02QUhjI5J55UKU388PEvdxjCsvLyc
qbraiSKv3uYDeMCiP5528OBBiURSXFwsl8uLioqcnJxSU1OZdCMtLU0mk+FqfOnSJRcXF01d
tHCWG8UWmPyhunmdyv0qFIqgoCAigu/atSs4OJgQFPsx08nMzLS2th4yZMjq1asPHjxYWVlJ
WaGxsdHb2zs7O9vHx4c8ewi9Yffu3cn1XzorV67cvn07/nvHjh0rVqzQbNlIoVCwmRmBiB3E
7tTK6NDvzUDDJtNQK4ij0wO1QjwFRMBSKU8OZSNtnwI+FsQU05XuTmWyTcA+qeCpdWpZlqGh
IaUQCQBQNkJB9iyGhobEA/w4ra2tRkZG+O+WlpawsDCy9YaFhbW2ttKPMDU1tX///hSfpZTT
p0+/8847RCcUU+czHnTPfMpGycnJnp6e5Mfjg4ODyRd1paWlAwcOJDa5fPkypZMbN24Qf2tr
a7t06cKmH6VDEolElDufOAEBAadOnVJ6CBz27u/vT378ITs7m1vZiCIKHx+f8vJy4mw6OjpS
3hRDwdvb+/vvv8dzEXd396NHj/bt25cwqgULFijd6uXLlz169OBzBhFlI4pY/P391VUqurGg
VdfIyEgmk5Gf7ZdIJCkpKWxaKfG4f//+L168QIxt7NixeFHj+fPnP/zwQ8+ePX/++WfyjbLs
7OzGxsbGxsasrCxnZ2djY2P+do3uGS06XXowCwsLysw4mUx25coVhNr89ttvZNMTCATkO9K1
tbVdu3Zlo1oqd0QxNIRFMDkKhEXoswtCXJ4x6TxdmHrl4VnqNn5VgJ48qP+RV5/zgQcPHvj7
+9vZ2VHe4Obj45OVlUUuPRBvw6Hrhp+fH/kRsJycHI1kJnzkRl7Ys2dPpbasbl7Hcr/V1dUy
maysrKysrEwmk1VXV6s7Zibq6+tPnDixbt26yZMnd+/efejQoZTjKi0tNTAwoNT90RsaGxsj
nv5ubW2VSCTEu2OePn3q5OSkUt/Yn/3W1taUlBQ3Nzc2aSpT7CB2xyGj45Ywq8w01A3i6PSA
fYhXK2CplCeHspG2TwEfC2KK6SpHSE+2uSUVmrpYY4Obm1tKSgpLJQEAKBs9YV+fXrJkSWBg
YFFREfltc5988gk9DMhksgcPHrCRhaur67Vr15hMnc940D1z9kRr1qwZPHgwZVRmZmbU7979
76aQQCCg+CP8gx1KHRy6H6VDWrp0qa2t7YIFCw4cOPDXX38Ry8ViMfk5FJ57F4vF5JtyDQ0N
3MpGFFEcPXo0KioK/52enh4UFITuc/PmzZGRkXiWPHz4cAzDhg0bhr+YYMSIEUQMrq6ujo6O
dnBwID44QhYjhzOIKBtRxCIWi9WtGdGNRaVR0J/td3V1ZdNK0NbWhn9lg7ilxoaCggKiToef
PvwBK7FYHBgYePjwYRsbG/52je4ZLTpdejAjIyOyPl+5ckUmk6H1n256TMaIUC02O6IYGsIi
mBwF2iLI9/30ygUh/JJSnacLU988PHuraWtrU1pd7USRV5/zgUmTJuXl5f3rX/9atGgR5RKL
opkikYhJN+grayQz4elvcTIyMiIiItQKVTw1FsMwvGDk7u5O3EBSa8xskMvlMTExo0aNUvfC
krJh9+7dEW8UzsjIoDxzN3XqVKIMwb9shH9pCzE7g7wmU+wgdscho+MGOtPgEMTR6QHLEK8U
RMBSKU8OZSNtnwI+FsQU0+kjRCfb7JOKDiwbnThxAv/sGtQmACgbqV02Qj8Na2FhQX9s2NLS
krwkKSnJ2dn53r176t6OUDoLkc94+MxvRIw2PT3dwsIiMzOTkgsyvUmRTVwhlqjVD0F5efm2
bdsmT55sZWW1efNmlSGQw941VTaiLGlvb/fw8Hj06BGGYYGBgenp6eg+q6qqzMzMGhoawsPD
8bcMHD16dOzYsS9evLC1tSUmmg4bNuyjjz6qrKxsamrCMEyhUJCvxnmewfb2dk2VjZiMBa26
3t7e9Gf7TUxM2LRSePr0qVpvi5TL5UKhkKn1+PHjxFUHH7tG94wWnS49mIWFBTkti42N/fTT
T7kZvlplIw47QlgEk6NAWIQ+uyCVfomi83Rh6qGHZ2k1as020s/Iq7f5QE5ODl4+kMvlvXv3
Js+KRZeN6GaljWtFjfjbyMhIpqqEunkd+/0mJiZ6e3tLpVLKK/n4vJmFzqtXr0xNTTlcWJI3
JLIOpeCfVKOAfroHU3O20d69e9k8harxshHPx4WYMg1uQRydHrAJ8dorG5GTQ82WjTicAp4W
pDSmq5VaKPV+7JMKnT2k5uPjk5SUBLONgNevbGQo0D6jR48+cuQIecmRI0dGjx5N2CrTG1hx
vvrqq61bt547d87JyYnlHhFXTTzHg+6ZM5MnTz569OiMGTPS0tKIhfjDVvzlz60fb2/vFStW
pKenl5WVbdiwAV/o6el57tw5Te3dw8Pj4sWLxN+CggKVvRkYGKiUtoGBwbJlyxITEysqKu7d
uzdx4kT0+jKZzM3NDbefcePGCQSCcePGXb16dc+ePaGhoSYmJvhqv/zyy9atW93c3EQikUAg
OH/+PJ8zaGZm9vz5c+LvzZs3ya0UsXh4eLCUNsJY0KobHh5eUVFBXr+iokIikbBppaBQKIRC
IXsNqaio6NWrl9Km1tbWrVu3Ll68mL9do3tGi06XHkwikdy+fZv4e+zYsUmTJqml/2iYVIvD
jhAWweQo1PJF+umC2Og8RZj66eFZWs3t27eZLL2zRF79HJVCoViyZMnmzZsFAoFQKNy0aRPZ
HfXr1+/ChQvE3wsXLgwYMICpq4EDBxYWFhJ/yb/5wN/f1tTUlJWVhYeHqxWqeGrstWvXvvji
ix9++CE9PX3+/Pl//vkn+20RfPLJJ21tbeQl1dXV1tbWPDeMiYnZsGFDU1MTZavNmzfX1NSc
PXv2+fPnlMkd+fn5NTU1GjnFRkZGM2fOvH79Op/Ywc2dcru2R2canIO4ysQDHeIRIAIWkzzR
ySEabZ8CPhbEFNPpyQYitaCvrFb44691LLl+/frMmTOJ2VIA8Fqh7dlGjx8/trOzi4+Pr6ur
q6uri4+P79GjB7HOokWLAgMDi4uL8bfNFRYW+vv7x8TE4K1xcXGurq7kCY38JxbyGQ/n2jOb
4ZWXl9vZ2e3Zswf/e/bsWV9f36Kioubm5vr6+rNnzxIf6FXrXjTLfsi/R48enZubW19f/+rV
q6SkpH79+uHLT5482bNnz7y8PLlcTnm9H4e9//jjj/iLPBUKRUlJCZtXYjs6Oubn55Mf1lC6
SUtLi6+v7/vvv79+/Xo2pyAuLs7Y2Jj8jsP169ebmJj8+OOP5LsH69atq6mpaWxsPHnyZI8e
Peg3QNifwfHjx0dHRz99+lShUBQWFuIZA9EbWSzOzs5Hjx5lo3JqGQuln5qamuDgYPKz/RKJ
hHhLK7p1/PjxBQUFDQ0Ncrm8rKwsJCSEPNUCU/bVtvz8/Pr6+qamppycHKlU+u233+JNYWFh
eXl5+BuUCgoKhg0b9tlnn2nErtE9o0WnSw82d+5c4ktqv/76q1QqVVf/0dd7SlWL244QFsHk
KBAWQUGvXBB9IULn6cLUEw/PQbcxDIuPj6e8343z12S0Gnk73ag2btw4bdo08pIhQ4YcOnQI
/33w4EFnZ+eSkhJCM8mvxKZ0lZaW5urqWlpaqlAoSktLXV1dmSI7nxxGLbkRyqPUgav0iohR
ofdbX1/fu3dvQlaJiYmenp74nAU2Y0ZPzfD19T158iQeuS5evOjj40PMmEDrAHrD2NhYHx+f
jIyMuro6/Azik4zi4+OnT59OH8mMGTPwGCHQ7ZfUmNISYnMOGZ1aoDMNPkEcnR6odAKIw0QE
LCZ5IpJDlWdQ26eAjwUxxXR6soFILegrs08qNHixpsE1AaBzzTbSVtlIIBCQb5LgX17s2rVr
165dw8LCbt68Sb7C37hxY58+fYRCoVAo7NOnz8aNG4l3BCqtc1Fuv3AwYM7j0WrZCMOwqqoq
FxeXLVu24H/Pnz8/bNiwLl26iMXikJCQjIwMDhcVLPsh/87MzBw6dCj+pefw8HDytz+OHTuG
f+pSIpHs27ePz94xDPvuu+/U+mzwoUOHHBwcyM8MM22ye/duoVD4+PFjNqegsrKSsvJ//vOf
bt26kee+VlVVjRgxQiQSmZqaenh4pKSkKB0DyzNYXV0dGRlpbm4uFAo9PT1TU1PJvX3zzTcu
Li7GxsZSqZQQMpu8lr2x0Pu5c+dOZGTkW2+9JRQKvby8jhw5wrI1MzMzJCREJBKJxWIvL6+d
O3cyvYSFsr6ZmVlAQAD5KcKTJ08GBgYKhUILC4vQ0FDiVdn87Rrds0rR6cyDZWRkBAcH47/X
rl1L/m4OS/1Hl42Uqha3HSEsgslRoL0BRUn0wQUx3atE6DxdmHri4ZlA6DaGYUFBQeTPh9fU
1Kj1zJpuIm+nG9X9+/ctLCz+/PNP8sLy8nIHBwfiGVXCVF1cXJKSktAhYM+ePU5OTrga79q1
i3jsFy0Z7ckNx8vLi/wOeJb+VuWoEPudOXPm7NmzyStPmzYtOjqazbbo/RYWFs6ePdvJycnY
2Njc3DwgICA5OZmNlNhsmJWVNWbMGGtra2Nj47fffnvixIlnz5719PTE37FIIT8/39PTk0mM
iOU8y0ZMaQl5c3UzOrVAZxp8gjg6PUA7AZXqyhSwmOSJSA7ZnEGtngI+FsQU0+nJBiK1oK/M
PqngeZmm1hNtUDYCXtey0X9t7+nTp5qdwWRjYwPTuIAOZNOmTTdv3jx06FCnGzn/B5GAzktL
S4tEIsnMzPT09Ozbt++BAwf8/Py0rVoa39GbzOskzCtXrkRERNy/f9/Y2BhfkpCQ8McffyQk
JOjVOGFUZCoqKj744AP82Rb0GEBu+i8NHWBsbNzc3EzYOKQlOlCb11Keb6wFUWhtbRWLxS0t
LWAdgD6za9eukJAQNmueP39+ypQpubm5UVFRhiA44PWjsLAwPj4+Li4ORAF0LkxMTJYuXRob
GysQCG7cuKGb6oPOdvQm8DoJc/Xq1UuXLiVfTyYnJ0dHR+vbOGFUM2bMqKqqam1tvXr16rx5
84j9oscActN/aeiAXr16ZWdnQ1UI1AZEwR8Mw7Kzs5ne1wkAnR2YbQS8djptYGBvb//tt9+G
hYV10vFDAgeAagEAwJKUlJS4uLh79+45ODhER0evWbPG0BBuCgKsOHLkyKpVq/7++2/Kq7sh
dkAsBtTFyMjI3t5+69at06dPB2kA+gy32UbGIDhADwOq0uUY6+/maLxPXQLJBACqBeiPRwX0
n1mzZs2aNQvkAHBg+vTpKi9xwVd0eCwGN94pQNReAeA1AMpGwBtxcQuRFQAA8KgAAAAAuHEA
AAB1gWnMAAAAAAAAAAAAAAAAgBKgbAQAAAAAAAAAAAAAAAAoAcpGAAAAAAAAAAAAAAAAgBKg
bAQAAAAAAAAAAAAAAAAoAcpGAAAAAAAAAAAAAAAAgBK09SW1p0+fgnABAAAAAAAAAAAAAAA6
LzDbCAAAAAAAAAAAAAAAAFAClI0AAAAAAAAAAAAAAAAAJWjrIbXc3Fz2Kz9//hzOBAC89lha
WoIQAAAAAAAAAHWBC0YA0MhFlqWl5bVr19Tt1lh7ox85ciSb1XJzc0NCQuBkA8Brz7Vr11i6
BQAAAAAAAACAC0YA0OBFFj65R62VceAhNQAAAAAAAAAAAAAAAEAJUDYCAAAAAAAAAAAAAAAA
lKDTslF7e/uaNWtA6AAAAAAAAAAAAAAAABpnzZo17e3tGuxQd2Wj5ubmOXPmJCUlwVkEAAAA
AAAAAAAAAADQOElJSXPmzGlubtZUhzoqG9XW1k6YMCEzMxNOIQAAAAAAAAAAAAAAgJbIzMyc
MGFCbW0tYp2VK1fa/l9WrlypdE0dlY0WLlxYXl4OJw8AAAAAAAAAAAAAAECrlJeXL1y4ELHC
5s2bR48eTfwdPXr05s2bla6po7LR7t27fXx84MwBAAAAAAAAAAAAAABoFR8fn927dyNWMDIy
2rt3r7e3t0Ag8Pb23rt3r5GRkdI1dVQ2srKy+umnn8LDw+HkAQAAAAAAAAAAAAAAaInw8PCf
fvrJysoKvZpYLE5NTR0+fHhqaqpYLGZaTXevxBaJRPv27Zs3bx6cQgAAAAAAAAAAAAAAAI0z
b968ffv2iUQiNitbW1unpaVZW1sj1jHW5egNDQ3j4uLgLAIAAAAAAAAAAAAAAGgcjVddDEGm
AAAAAAAAAAAAAAAAAB0oGwEAAAAAAAAAAAAAAABKMBAIBBiGPX36NDc3t6MG8fz5czgTAPDa
Y2lpCUIAAAAAAAAA4IIRAPT/ImvkyJG5ublRUVHG5EUgcQAAAAAAAAAAAAAAAAAHHlIDAAAA
AAAAAAAAAAAAlABlIwAAAAAAAAAAAAAAAEAJxiCCzkUHvoJKLT744AOmptTUVDZPRHaWI+28
EkYLX5dPrYJWA6+fVkPQARN700wMAAAAYjRcHkKUf12jPJSNXiuF0CuePn36hhxp55UwaDVo
NWg1oFdKCyYGJgYAAABAIg1RXt+iPDykBgAAAAAAAAAAAAAAACgBykYAAAAAAAAAAAAAAACA
EqBsBAAAAAAAAAAAAAAAACgBykYAAAAAAAAAAAAAAACAEv5bNrJlBm/V6iCU7hRQSUFBwZQp
U2xsbExNTfv3779r1y4Mw+irPXz4UCqVGhgY0JsyMzNHjRplZWUlEomCgoJOnTrFpvX48eMT
JkywtrYWCoV9+vTZtm1bW1sb0yCbmprmzJnT1NTE82ANaJBb09LSfH19RSKRpaXlpEmT7t69
y14Ot27dCg8PNzc3Nzc3j4iIqKysZN+KHhWfVpXnTuMS1jYs7Rq0WiNaXVFRsXDhQgsLC3qT
yiNFjErl2UHYC71bU1PTDtHqDo93ndc8VbpETaEpBUAYgkplVmmACFeDMCK1XI326CyBAwCA
N5Zz58598MEH7u7u9vb2/fr1mz17dkFBgd6muB2YV0AirePLQ5UJLWJbtJTa2tq2b98+YMAA
kUgkEokGDBiwfft28grsczBtRPn/lo2ekKD/1QFP/i+dxaPxdAQ8Nx86dGhtbW1GRkZ9ff0P
P/xw9OjRDRs20FdbsGDB559/Tl++du3aHTt2xMbG/vXXXzU1NevWrfvmm2/YtB44cCAyMvLX
X39tbGz8+eefL1y4sGzZMqZBrly58tSpUytXruQvbez/QixPTk6OjY3dsGFDbW3to0ePoqOj
Z8yY8fz5czZyqK6uHjZs2KhRox4+fPjw4cORI0cOHz782bNnbFrRo+Lfijh3WpKwPgBazV+r
BQLBjBkzbG1tCwsL6U1sjpRpVOizg7YXSp9JSUnjx4/vEK3u8HjXSUtLLF2iRtCUAiAMAa3M
Kg0Q7WoQRqSWq9Eer1ngAADgNWPr1q0bN26cNWtWSUnJ/fv3U1NTDQwMJk2apJ9xWa/yCkik
tX15iE5o0duipfTxxx+fPHny22+/raurq6urS0pKOnHixMcff8whB9NGlDfAD578qTZbW1sd
a7nu96gnI+eweW5uLvHdwc8++2zTpk1EffTRo0fe3t7V1dWUOmtycnJubq6BgQHZls6cObN2
7dpffvnF2NiYvhd0K91Xurq6vnjxgrKc6ft/ubm5I0eOVOtIBQIBZfxkXF1dDx8+PGjQIGJJ
cXHx6dOnv/zyS5Vy+Oyzz5qamr7++muyxXbt2jUuLk5lK3pUPFsRY9aUhNHC59mDWtoOWq1Z
rVZLzehHitgEfXZU2guZwYMHf/nllyNGjOhYrdbPeKdXo6KYJ/tTzA3NmhhCq9HKjDZAlc5E
pd2pdDXaQ3smBgAAoJEYff78+S+//DI7O1skEpHXiY+PX7JkiZ5f8XXIVS0k0rq8PEQntGpt
S5FSt27dKisre/ToQazw999/u7u7v3z5kn3P2ojyubm5UVFRhiwNgPhx7NixkSNH9urVSyKR
TJo06datW3l5eeHh4U5OThKJ5B//+EdNTQ2x4enTp4cPH+7o6Ojt7Z2amsrBRI8dOzZ69GiJ
RGJnZ0fIYuXKlb169erbt++qVauIyVdaHdsff/wxbdo0FxcXR0fH0NDQEydOEGKhP1iHHiFx
OEybs7/PvHnzZvKcOqFQSJmKVlNT89lnn+3du5e+7c6dOz/99FMms0e3UjAyMmK5JkvBqsv9
+/e9vb3JS3x8fDIzM9nI4fTp09OnTycvmT59enZ2NptWrYIYMwcjevfddx0dHV1cXKKjowkr
YC98JmNBdC4QCL7//vt33nnHwcFh0KBBKSkpSl0KaLU2tFot1DpS9Nlhby+VlZWPHz8ODQ3t
QK3u8HjHdBRMoQFthnhksbW17d27N+Vm2vPnz93d3fGFTOGJpXl2oEvUuImhlRltgGo5E+25
Gq1eIGnPxAAAANB89913y5cvp9SMBAIBXjOiBylK4CZfOSq9llQ3rWWKyx2YV0Ai3YGXh+iE
Vq1MiSIlus4LBAKxWKzxHIxblFf7ldjx8fEbNmy4ffv2lStXpFLpuHHj4uLi1q5dW1VVdeXK
FRsbm+XLl+Nrnjt37qOPPlq+fPmdO3cOHz68a9eu06dPq7u7r7/+esOGDVVVVY8fP8aXhIaG
+vj4VFVV5eXlvXr1ijzvTntjmz17dmho6NWrV+/cubNt27aff/4ZLxAKSBMRiZURIyQfDtPm
nNmxY8eMGTPIS5YuXbp48WKpVEpf+dKlS01NTUFBQWZmZl26dAkMDPzpp59YthJgGHb37t15
8+bNnj2b25iVChah4sbGxra2tuPHjy8uLiaWOzk5VVRUkNesqKioqqpiI4c///yzT58+5CXu
7u63b99m04oeFc9WxJjVJSEhYfPmzXfu3Ll8+bK5ufknn3yilvDRxsLUeVZW1ldffbV37967
d+/u3r07ISEBtFpnWs0SxJGi9Zbp7LCxF5z9+/dHR0ejX9qlVa3Wk3in9CiUhgZ0/0RkefLk
SURExKFDh8h7OXjwYHh4uKWlJTo8sYH9KdYqmj3LSpUZbYBsnIlKI+LvarSKbkwMAACATllZ
mb+/P7dt6VeOlCUc0loNXrLp+DoaEmltXB6iE1qW2yqV0qJFi6ZMmXLp0iW5XC6Xy0tKSiZP
nrx48WJt5GAcojyrh9SIJba2thcvXuzduze+vK6uzs3NjbLEy8sLf+PU2LFjP/zww7CwMLzp
6tWrH3/88fnz5xFVWAJidzk5OV5eXkwHXF9fHxAQcP36de2NDadnz56XL18mzxljkhV6hJTD
4fmQGpkjR45s3ry5qKjI3NwcX5KTk7N27dri4mIjIyMBbRafsbGxVCrduXPn0KFDBQLB+fPn
Fy1a9OWXX86cOVNl639V538W0r9//8LCwm7dupHHg77ZTsyRYxIs/UjHjRu3fPlyPz+/pqam
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
E+38fB8AAAAASUVORK5CYII=

--IS0zKkzwUGydFO0o--
