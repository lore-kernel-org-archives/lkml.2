Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab0HIO67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:58:59 -0400
Received: from smtp.nokia.com ([192.100.105.134]:55078 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab0HIO6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:58:53 -0400
Date: Mon, 9 Aug 2010 18:02:11 +0300
From: Pauli Nieminen <ext-pauli.nieminen@nokia.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Lindgren <tony@atomide.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jarkko Nikula <jhnikula@gmail.com>, linux-kernel@vger.kernel.org,
        Pauli <suokkos@gmail.com>
Subject: IPC between application and xserver is causing extra context
 switches
Message-ID: <20100809150211.GA29771@burn-it>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Aug 2010 14:58:09.0657 (UTC) FILETIME=[480C1690:01CB37D3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

While running rendering benchmark we noticed huge context switch numbers that
were a lot larger than excepted. Numbers were showing 20-30 context switches
per frame. Theoretical minimum context switches is less than 10.

Problem was traced using FineToothComp (FTC) [1]. Tracing down to per
instruction view what happens in system.

Conext switches are relatively easy to track down from the trace
visualization so it was easy to find out what was causing the extra context
switches.

 * What application is doing when calling xserver?

Application opens unix socket connection to xserver. Communication is based
on simple message protocol. Application does following call sequence when
communicating to xserver.

writev(...) // Send message(s) to xserver

poll(...) // wait for response(s) from xserver

read(...) // read the response(s)

 * Where does extra context switches happen?

Application developer would except that only poll call would trigger context
switch. But in worst case every system call is triggering context switch.

- writev()

writev does implicit context switch in kernel after writing to socket. This
isn't perfect behavior for asynchronous IPC because application might want to
queue up more messages before context switch.

This doesn't affect X communication because there is buffering implementation
in xcb for asynchronous operations. But it might be good to fix for some
other implementations that don't have buffering.

- poll()

But scheduling in writev backfires when poll is called. There is some X calls
(DRI2GetBuffers etc) that takes very long to handle. While xserver is handlnig
the request kernel decides to schedule client before there is response.

Now client executes very few instructions before hitting the poll. Now poll
blocks because there is no response from xserver.

- read()

Application hits read soon after returning from poll. xserver has gone to
sleep in select call waiting for multiple file descriptor.

When read call is returning from kernel unlocking the socket triggers xserver
scheduling. This schedulnig never returns from kernel space but it iterates
over all file descriptors that xserver is waiting for.

 * Test case

There is relatively simple test case attached that can check if kernel is
scheduling too many times. Test case is xwininfo tool modified not to output
anything. Running it with -root and -tree parameters is generating lots of
request for xserver.

Compilation instructions are in  xwininfo.c. 

test.sh can be used to automatically test if there was too many extra
scheduling. In perfect case scheduling should be only twice the number of
request.

 * Where the bug has been seen?

I first saw this while doing development on arm. I have also tested a few x86
kernels to see if problem can be reproduced there too. Problem was
reproducing in most of configurations that I tested.

broken:
2.6.32 (ARM)
2.6.28 (x86 Debian Lenny)
2.6.35-rc4 (x86 vanila, Ubuntu Karmic user space)

But for my surprise I could find single working configuration that was my
work desktop using Ubuntu kernel.

correctly working:
2.6.31 (x86 Ubuntu Karmic)

 * Bisecting failed

I tried to bisect if I could find the kernel commit that has fixed the
problem for Ubuntu karmic but I hit problem that my self compiled kernels
didn't boot. I don't have enough time now to try to do the bisecting.

If bisecting would help I can try to find some time.


There is still open question if the bug is caused by userspace doing stupid
stuff with unix socket or actual kernel problem. But my debugging is pointing
to kernel problem because same userspace hits the bug with different kernel.

Pauli

[1] QT blog post explaining what can be done with FTC
http://labs.trolltech.com/blogs/2009/09/29/exploring-qt-performance-on-arm-using-finetoothcomb/

--0F1p//8PRICkK4MW
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="xwininfo.c"

/**
 * Compile: gcc -DHAVE_CONFIG_H -I. -g -O2 -o xwininfo xwininfo.c -lXext -lX11
 * test case:
 * 1. Count number of writes to xserver.
 *  strace ./xwininfo -root -tree 2>&1 | grep writev | wc
 * 2. Compare that value to number of context switches happening while running
 *    xwininfo.
 *  vmstat -n 1 & sleep 3; ./xwininfo -root -tree; sleep 3; killall vmstat
 * 3. Compare how context switch numbers increase with number of runs
 *  vmstat -n 1 & sleep 3; echo START; for i in 1 2; do ./xwininfo -root -tree; done; echo END; sleep 3; killall vmstat
 *  vmstat -n 1 & sleep 3; echo START; for i in 1 2 3; do ./xwininfo -root -tree; done; echo END; sleep 3; killall vmstat
 *  vmstat -n 1 & sleep 3; echo START; for i in 1 2 3 4 5; do ./xwininfo -root -tree; done; echo END; sleep 3; killall vmstat
 **/

/* config.h.  Generated from config.h.in by configure.  */
/* config.h.in.  Generated from configure.ac by autoheader.  */

/* Define to 1 if you have the `strlcat' function. */
/* #undef HAVE_STRLCAT */

/* Name of package */
#define PACKAGE "xwininfo"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "https://bugs.freedesktop.org/enter_bug.cgi?product=xorg"

/* Define to the full name of this package. */
#define PACKAGE_NAME "xwininfo"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "xwininfo 1.0.4"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "xwininfo"

/* Define to the version of this package. */
#define PACKAGE_VERSION "1.0.4"

/* Major version of this package */
#define PACKAGE_VERSION_MAJOR 1

/* Minor version of this package */
#define PACKAGE_VERSION_MINOR 0

/* Patch version of this package */
#define PACKAGE_VERSION_PATCHLEVEL 4

/* Version number of package */
#define VERSION "1.0.4"


/*
 * Copyright 2007 Kim woelders
 *
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both that copyright
 * notice and this permission notice appear in supporting documentation, and
 * that the name of the copyright holders not be used in advertising or
 * publicity pertaining to distribution of the software without specific,
 * written prior permission.  The copyright holders make no representations
 * about the suitability of this software for any purpose.  It is provided "as
 * is" without express or implied warranty.
 *
 * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
 * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
 * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
 * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
 * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
 * OF THIS SOFTWARE.
 */
#ifndef _CLIENTWIN_H_
#define _CLIENTWIN_H_

#include <X11/Xlib.h>

extern Window Find_Client(Display * dpy, Window root, Window target_win);

#endif


/* $Xorg: dsimple.h,v 1.4 2001/02/09 02:05:54 xorgcvs Exp $ */
/*

Copyright 1993, 1998  The Open Group

Permission to use, copy, modify, distribute, and sell this software and its
documentation for any purpose is hereby granted without fee, provided that
the above copyright notice appear in all copies and that both that
copyright notice and this permission notice appear in supporting
documentation.

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of The Open Group shall
not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization
from The Open Group.

*/
/* $XFree86: xc/programs/xlsfonts/dsimple.h,v 1.8 2002/12/24 17:43:01 tsi Exp $ */

/*
 * Just_display.h: This file contains the definitions needed to use the
 *                 functions in just_display.c.  It also declares the global
 *                 variables dpy, screen, and program_name which are needed to
 *                 use just_display.c.
 *
 * Written by Mark Lillibridge.   Last updated 7/1/87
 *
 * Send bugs, etc. to chariot@athena.mit.edu.
 */

    /* Simple helper macros */
#ifndef MAX
#define MAX(a,b) (((a)>(b))?(a):(b))
#endif /* MAX */
#ifndef MIN
#define MIN(a,b) (((a)<(b))?(a):(b))
#endif /* MIN */

    /* Global variables used by routines in dsimple.c */

extern char *program_name;                   /* Name of this program */
extern Display *dpy;                         /* The current display */
extern int screen;                           /* The current screen */

#define INIT_NAME program_name=argv[0]        /* use this in main to setup
                                                 program_name */

    /* Declaritions for functions in dsimple.c */

char *Get_Display_Name(int *, char **);
Display *Open_Display(char *);
void Setup_Display_And_Screen(int *, char **);
void Close_Display(void);
Window Select_Window_Args(int *, char **);
void usage(void);

#define X_USAGE "[host:display]"              /* X arguments handled by
						 Get_Display_Name */

/*
 * Other_stuff.h: Definitions of routines in other_stuff.
 *
 * Written by Mark Lillibridge.   Last updated 7/1/87
 *
 * Send bugs, etc. to chariot@athena.mit.edu.
 */

Window Select_Window(Display *, int);
Window Window_With_Name(Display *, Window, char *);
#ifdef __GNUC__
void Fatal_Error(char *, ...) __attribute__((__noreturn__));
#else
void Fatal_Error(char *, ...);
#endif

/*
 * Copyright 2007 Kim woelders
 *
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both that copyright
 * notice and this permission notice appear in supporting documentation, and
 * that the name of the copyright holders not be used in advertising or
 * publicity pertaining to distribution of the software without specific,
 * written prior permission.  The copyright holders make no representations
 * about the suitability of this software for any purpose.  It is provided "as
 * is" without express or implied warranty.
 *
 * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
 * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
 * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
 * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
 * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
 * OF THIS SOFTWARE.
 */
#include <X11/Xatom.h>
#include <X11/Xlib.h>

static Atom atom_wm_state = None;

/*
 * Check if window has given property
 */
static Bool
Window_Has_Property(Display * dpy, Window win, Atom atom)
{
    Atom type_ret;
    int format_ret;
    unsigned char *prop_ret;
    unsigned long bytes_after, num_ret;

    type_ret = None;
    prop_ret = NULL;
    XGetWindowProperty(dpy, win, atom, 0, 0, False, AnyPropertyType,
                       &type_ret, &format_ret, &num_ret,
                       &bytes_after, &prop_ret);
    if (prop_ret)
        XFree(prop_ret);

    return (type_ret != None) ? True : False;
}

/*
 * Check if window is viewable
 */
static Bool
Window_Is_Viewable(Display * dpy, Window win)
{
    Bool ok;
    XWindowAttributes xwa;

    XGetWindowAttributes(dpy, win, &xwa);

    ok = (xwa.class == InputOutput) && (xwa.map_state == IsViewable);

    return ok;
}

/*
 * Find a window that has WM_STATE set in the window tree below win.
 * Unmapped/unviewable windows are not considered valid matches.
 * Children are searched in top-down stacking order.
 * The first matching window is returned, None if no match is found.
 */
Window
Find_Client_In_Children(Display * dpy, Window win)
{
    Window root, parent;
    Window *children;
    unsigned int n_children;
    int i;

    if (!XQueryTree(dpy, win, &root, &parent, &children, &n_children))
        return None;
    if (!children)
        return None;

    /* Check each child for WM_STATE and other validity */
    win = None;
    for (i = (int) n_children - 1; i >= 0; i--) {
        if (!Window_Is_Viewable(dpy, children[i])) {
            children[i] = None; /* Don't bother descending into this one */
            continue;
        }
        if (!Window_Has_Property(dpy, children[i], atom_wm_state))
            continue;

        /* Got one */
        win = children[i];
        goto done;
    }

    /* No children matched, now descend into each child */
    for (i = (int) n_children - 1; i >= 0; i--) {
        if (children[i] == None)
            continue;
        win = Find_Client_In_Children(dpy, children[i]);
        if (win != None)
            break;
    }

  done:
    XFree(children);

    return win;
}

/*
 * Find virtual roots (_NET_VIRTUAL_ROOTS)
 */
unsigned long *
Find_Roots(Display * dpy, Window root, unsigned int *num)
{
    Atom type_ret;
    int format_ret;
    unsigned char *prop_ret;
    unsigned long bytes_after, num_ret;
    Atom atom;

    *num = 0;
    atom = XInternAtom(dpy, "_NET_VIRTUAL_ROOTS", False);
    if (!atom)
        return NULL;

    type_ret = None;
    prop_ret = NULL;
    if (XGetWindowProperty(dpy, root, atom, 0, 0x7fffffff, False,
                           XA_WINDOW, &type_ret, &format_ret, &num_ret,
                           &bytes_after, &prop_ret) != Success)
        return NULL;

    if (prop_ret && type_ret == XA_WINDOW && format_ret == 32) {
        *num = num_ret;
        return ((unsigned long *) prop_ret);
    }
    if (prop_ret)
        XFree(prop_ret);

    return NULL;
}

/*
 * Find child window at pointer location
 */
static Window
Find_Child_At_Pointer(Display * dpy, Window win)
{
    Window root_return, child_return;
    int dummyi;
    unsigned int dummyu;

    XQueryPointer(dpy, win, &root_return, &child_return,
                  &dummyi, &dummyi, &dummyi, &dummyi, &dummyu);

    return child_return;
}

/*
 * Find client window at pointer location
 *
 * root   is the root window.
 * subwin is the subwindow reported by a ButtonPress event on root.
 *
 * If the WM uses virtual roots subwin may be a virtual root.
 * If so, we descend the window stack at the pointer location and assume the
 * child is the client or one of its WM frame windows.
 * This will of course work only if the virtual roots are children of the real
 * root.
 */
Window
Find_Client(Display * dpy, Window root, Window subwin)
{
    unsigned long *roots;
    unsigned int i, n_roots;
    Window win;

    /* Check if subwin is a virtual root */
    roots = Find_Roots(dpy, root, &n_roots);
    for (i = 0; i < n_roots; i++) {
        if (subwin != roots[i])
            continue;
        win = Find_Child_At_Pointer(dpy, subwin);
        if (win == None)
            return subwin;      /* No child - Return virtual root. */
        subwin = win;
        break;
    }
    if (roots)
        XFree(roots);

    if (atom_wm_state == None) {
        atom_wm_state = XInternAtom(dpy, "WM_STATE", False);
        if (!atom_wm_state)
            return subwin;
    }

    /* Check if subwin has WM_STATE */
    if (Window_Has_Property(dpy, subwin, atom_wm_state))
        return subwin;

    /* Attempt to find a client window in subwin's children */
    win = Find_Client_In_Children(dpy, subwin);
    if (win != None)
        return win;             /* Found a client */

    /* Did not find a client */
    return subwin;
}
/* $Xorg: dsimple.c,v 1.4 2001/02/09 02:05:54 xorgcvs Exp $ */
/*

Copyright 1993, 1998  The Open Group

Permission to use, copy, modify, distribute, and sell this software and its
documentation for any purpose is hereby granted without fee, provided that
the above copyright notice appear in all copies and that both that
copyright notice and this permission notice appear in supporting
documentation.

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of The Open Group shall
not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization
from The Open Group.

*/
/* $XFree86: xc/programs/xlsfonts/dsimple.c,v 3.6 2001/12/14 20:02:09 dawes Exp $ */

#include <X11/Xos.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/cursorfont.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
/*
 * Other_stuff.h: Definitions of routines in other_stuff.
 *
 * Written by Mark Lillibridge.   Last updated 7/1/87
 */


/*
 * Just_display: A group of routines designed to make the writing of simple
 *               X11 applications which open a display but do not open
 *               any windows much faster and easier.  Unless a routine says
 *               otherwise, it may be assumed to require program_name, dpy,
 *               and screen already defined on entry.
 *
 * Written by Mark Lillibridge.   Last updated 7/1/87
 */


/* This stuff is defined in the calling program by just_display.h */
char    *program_name = "unknown_program";
Display *dpy = NULL;
int      screen = 0;


/*
 * Get_Display_Name (argc, argv) Look for -display, -d, or host:dpy (obselete)
 * If found, remove it from command line.  Don't go past a lone -.
 */
char *Get_Display_Name(
    int *pargc,  /* MODIFIED */
    char **argv) /* MODIFIED */
{
    int argc = *pargc;
    char **pargv = argv+1;
    char *displayname = NULL;
    int i;

    for (i = 1; i < argc; i++) {
	char *arg = argv[i];

	if (!strcmp (arg, "-display") || !strcmp (arg, "-d")) {
	    if (++i >= argc) usage ();

	    displayname = argv[i];
	    *pargc -= 2;
	    continue;
	}
	if (!strcmp(arg,"-")) {
		while (i<argc)
			*pargv++ = argv[i++];
		break;
	}
	*pargv++ = arg;
    }

    *pargv = NULL;
    return (displayname);
}



/*
 * Open_Display: Routine to open a display with correct error handling.
 *               Does not require dpy or screen defined on entry.
 */
Display *Open_Display(char *display_name)
{
	Display *d;

	d = XOpenDisplay(display_name);
	if (d == NULL) {
	    fprintf (stderr, "%s:  unable to open display '%s'\n",
		     program_name, XDisplayName (display_name));
	    usage ();
	    /* doesn't return */
	}

	return(d);
}


/*
 * Setup_Display_And_Screen: This routine opens up the correct display (i.e.,
 *                           it calls Get_Display_Name) and then stores a
 *                           pointer to it in dpy.  The default screen
 *                           for this display is then stored in screen.
 *                           Does not require dpy or screen defined.
 */
void Setup_Display_And_Screen(
    int *argc,      /* MODIFIED */
    char **argv)    /* MODIFIED */
{
	char *displayname = NULL;
        
        displayname = Get_Display_Name(argc, argv);
	dpy = Open_Display (displayname);
	screen = XDefaultScreen(dpy);
}

/*
 * Close_Display: Close display
 */
void Close_Display(void)
{
    if (dpy == NULL)
      return;
      
    XCloseDisplay(dpy);
    dpy = NULL;
}


/*
 * Select_Window_Args: a rountine to provide a common interface for
 *                     applications that need to allow the user to select one
 *                     window on the screen for special consideration.
 *                     This routine implements the following command line
 *                     arguments:
 *
 *                       -root            Selects the root window.
 *                       -id <id>         Selects window with id <id>. <id> may
 *                                        be either in decimal or hex.
 *                       -name <name>     Selects the window with name <name>.
 *
 *                     Call as Select_Window_Args(&argc, argv) in main before
 *                     parsing any of your program's command line arguments.
 *                     Select_Window_Args will remove its arguments so that
 *                     your program does not have to worry about them.
 *                     The window returned is the window selected or 0 if
 *                     none of the above arguments was present.  If 0 is
 *                     returned, Select_Window should probably be called after
 *                     all command line arguments, and other setup is done.
 *                     For examples of usage, see xwininfo, xwd, or xprop.
 */
Window Select_Window_Args(
    int *rargc,
    char **argv)
#define ARGC (*rargc)
{
	int nargc=1;
	int argc;
	char **nargv;
	Window w=0;

	nargv = argv+1; argc = ARGC;
#define OPTION argv[0]
#define NXTOPTP ++argv, --argc>0
#define NXTOPT if (++argv, --argc==0) usage()
#define COPYOPT nargv++[0]=OPTION, nargc++

	while (NXTOPTP) {
		if (!strcmp(OPTION, "-")) {
			COPYOPT;
			while (NXTOPTP)
			  COPYOPT;
			break;
		}
		if (!strcmp(OPTION, "-root")) {
			w=RootWindow(dpy, screen);
			continue;
		}
		if (!strcmp(OPTION, "-name")) {
			NXTOPT;
			w = Window_With_Name(dpy, RootWindow(dpy, screen),
					     OPTION);
			if (!w)
			  Fatal_Error("No window with name %s exists!",OPTION);
			continue;
		}
		if (!strcmp(OPTION, "-id")) {
			NXTOPT;
			w=0;
			sscanf(OPTION, "0x%lx", &w);
			if (!w)
			  sscanf(OPTION, "%lu", &w);
			if (!w)
			  Fatal_Error("Invalid window id format: %s.", OPTION);
			continue;
		}
		COPYOPT;
	}
	ARGC = nargc;
	
	return(w);
}

/*
 * Other_stuff: A group of routines which do common X11 tasks.
 *
 * Written by Mark Lillibridge.   Last updated 7/1/87
 */


/*
 * Routine to let user select a window using the mouse
 */

Window Select_Window(Display *dpy, int descend)
{
  int status;
  Cursor cursor;
  XEvent event;
  Window target_win = None, root = RootWindow(dpy,screen);
  int buttons = 0;

  /* Make the target cursor */
  cursor = XCreateFontCursor(dpy, XC_crosshair);

  /* Grab the pointer using target cursor, letting it room all over */
  status = XGrabPointer(dpy, root, False,
			ButtonPressMask|ButtonReleaseMask, GrabModeSync,
			GrabModeAsync, root, cursor, CurrentTime);
  if (status != GrabSuccess) Fatal_Error("Can't grab the mouse.");

  /* Let the user select a window... */
  while ((target_win == None) || (buttons != 0)) {
    /* allow one more event */
    XAllowEvents(dpy, SyncPointer, CurrentTime);
    XWindowEvent(dpy, root, ButtonPressMask|ButtonReleaseMask, &event);
    switch (event.type) {
    case ButtonPress:
      if (target_win == None) {
	target_win = event.xbutton.subwindow; /* window selected */
	if (target_win == None) target_win = root;
      }
      buttons++;
      break;
    case ButtonRelease:
      if (buttons > 0) /* there may have been some down before we started */
	buttons--;
       break;
    }
  } 

  XUngrabPointer(dpy, CurrentTime);      /* Done with pointer */

  if (!descend || (target_win == root))
    return(target_win);

  target_win = Find_Client(dpy, root, target_win);

  return(target_win);
}


/*
 * Window_With_Name: routine to locate a window with a given name on a display.
 *                   If no window with the given name is found, 0 is returned.
 *                   If more than one window has the given name, the first
 *                   one found will be returned.  Only top and its subwindows
 *                   are looked at.  Normally, top should be the RootWindow.
 */
Window Window_With_Name(
    Display *dpy,
    Window top,
    char *name)
{
	Window *children, dummy;
	unsigned int nchildren;
	int i;
	Window w=0;
	char *window_name;

	if (XFetchName(dpy, top, &window_name) && !strcmp(window_name, name))
	  return(top);

	if (!XQueryTree(dpy, top, &dummy, &dummy, &children, &nchildren))
	  return(0);

	for (i=0; i<nchildren; i++) {
		w = Window_With_Name(dpy, children[i], name);
		if (w)
		  break;
	}
	if (children) XFree ((char *)children);
	return(w);
}


/*
 * Standard fatal error routine - call like printf
 * Does not require dpy or screen defined.
 */
void Fatal_Error(char *msg, ...)
{
	va_list args;
	fflush(stdout);
	fflush(stderr);
	fprintf(stderr, "%s: error: ", program_name);
	va_start(args, msg);
	vfprintf(stderr, msg, args);
	va_end(args);
	fprintf(stderr, "\n");
        Close_Display();
	exit(EXIT_FAILURE);
}
/* $XdotOrg: $ */
/* $Xorg: xwininfo.c,v 1.4 2001/02/09 02:06:04 xorgcvs Exp $ */
/*

Copyright 1987, 1998  The Open Group
Copyright 1999 Sun Microsystems, Inc.

Permission to use, copy, modify, distribute, and sell this software and its
documentation for any purpose is hereby granted without fee, provided that
the above copyright notice appear in all copies and that both that
copyright notice and this permission notice appear in supporting
documentation.

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
HOLDERS INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL
INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING
FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Except as contained in this notice, the name of a copyright holder
shall not be used in advertising or otherwise to promote the sale, use
or other dealings in this Software without prior written authorization
of the copyright holder.

*/
/* $XFree86: xc/programs/xwininfo/xwininfo.c,v 1.9 2003/09/09 22:08:25 herrb Exp $ */


/*
 * xwininfo.c	- MIT Project Athena, X Window system window
 *		  information utility.
 *
 *
 *	This program will report all relevant information
 *	about a specific window.
 *
 *  Author:	Mark Lillibridge, MIT Project Athena
 *		16-Jun-87
 */

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include <X11/extensions/shape.h>
#ifndef NO_I18N
#include <X11/Xlocale.h>
#endif
#include <stdio.h>
#include <stdlib.h>

/* Include routines to handle parsing defaults */

#define printf /* */

typedef struct {
	long code;
	const char *name;
} binding;

static void scale_init(void);
static char *nscale(int, int, int, char *, size_t);
static char *xscale(int);
static char *yscale(int);
static char *bscale(int);
static int bad_window_handler(Display *, XErrorEvent *);
int main(int, char **);
static const char *LookupL(long, const binding *);
static const char *Lookup(int, const binding *);
static void Display_Window_Id(Window, int);
static void Display_Stats_Info(Window);
static void Display_Bits_Info(Window);
static void Display_Event_Mask(long);
static void Display_Events_Info(Window);
static void Display_Tree_Info(Window, int);
static void display_tree_info_1(Window, int, int);
static void Display_Hints(XSizeHints *);
static void Display_Size_Hints(Window);
static void Display_Window_Shape(Window);
static void Display_WM_Info(Window);

static char *window_id_format = "0x%lx";

#ifndef HAVE_STRLCAT
static size_t strlcat(char *dst, const char *src, size_t dstsize)
{
    size_t sd = strlen(dst);
    size_t ss = strlen(src);
    size_t s = sd + ss;
    
    if (s < dstsize) {
	strcpy(dst + sd, src);
    } else {
	strncpy(dst + sd, src, dstsize-sd-1);
	dst[dstsize] = '\0';
    }
    return s;
}
#endif

/*
 * Report the syntax for calling xwininfo:
 */
void
usage(void)
{
    fprintf (stderr,
	"usage:  %s [-options ...]\n\n", program_name);
    fprintf (stderr,
	"where options include:\n");
    fprintf (stderr,
	"    -help                print this message\n");
    fprintf (stderr,
	"    -display host:dpy    X server to contact\n");
    fprintf (stderr,
	"    -root                use the root window\n");
    fprintf (stderr,
	"    -id windowid         use the window with the specified id\n");
    fprintf (stderr,
	"    -name windowname     use the window with the specified name\n");
    fprintf (stderr,
	"    -int                 print window id in decimal\n");
    fprintf (stderr,
	"    -children            print parent and child identifiers\n");
    fprintf (stderr,
	"    -tree                print children identifiers recursively\n");
    fprintf (stderr,
	"    -stats               print window geometry [DEFAULT]\n");
    fprintf (stderr,
	"    -bits                print window pixel information\n");
    fprintf (stderr,
	"    -events              print events selected for on window\n");
    fprintf (stderr,
	"    -size                print size hints\n");
    fprintf (stderr,
	"    -wm                  print window manager hints\n");
    fprintf (stderr,
	"    -shape               print shape extents\n");
    fprintf (stderr,
	"    -frame               don't ignore window manager frames\n");
    fprintf (stderr,
	"    -english             print sizes in english units\n");
    fprintf (stderr,
	"    -metric              print sizes in metric units\n");
    fprintf (stderr,
	"    -all                 -tree, -stats, -bits, -events, -wm, -size, -shape\n");
    fprintf (stderr,
	"\n");
    exit (1);
}

/*
 * pixel to inch, metric converter.
 * Hacked in by Mark W. Eichin <eichin@athena> [eichin:19880619.1509EST]
 *
 * Simply put: replace the old numbers with string print calls.
 * Returning a local string is ok, since we only ever get called to
 * print one x and one y, so as long as they don't collide, they're
 * fine. This is not meant to be a general purpose routine.
 *
 */

#define getdsp(var,fn) var = fn(dpy, DefaultScreen(dpy))
static int xp=0, xmm=0;
static int yp=0, ymm=0;
static int bp=0, bmm=0;
static int english = 0, metric = 0;

static void
scale_init(void)
{
  getdsp(yp,  DisplayHeight);
  getdsp(ymm, DisplayHeightMM);
  getdsp(xp,  DisplayWidth);
  getdsp(xmm, DisplayWidthMM);
  bp  = xp  + yp;
  bmm = xmm + ymm;
}

#define MILE (5280*12)
#define YARD (3*12)
#define FOOT (12)

static char *
nscale(int n, int np, int nmm, char *nbuf, size_t nbufsize)
{
    int s;
    snprintf(nbuf, nbufsize, "%d", n);
    
    if (metric||english) {
	s = strlcat(nbuf, " (", nbufsize);

	if (metric) {
	    snprintf(nbuf+s, nbufsize-s, "%.2f mm%s",
		     ((double) n)*nmm/np, english ? "; " : "");
	}
	if (english) {
	    double inch_frac;
	    Bool printed_anything = False;
	    int mi, yar, ft, inr;

	    inch_frac = ((double) n)*(nmm/25.4)/np;
	    inr = (int)inch_frac;
	    inch_frac -= (double)inr;
	    if (inr >= MILE) {
		mi = inr/MILE;
		inr %= MILE;
		s = strlen(nbuf);
		snprintf(nbuf+s, nbufsize-s, "%d %s(?!?)",
			 mi, (mi==1) ? "mile" : "miles");
		printed_anything = True;
	    }
	    if (inr >= YARD) {
		yar = inr/YARD;
		inr %= YARD;
		if (printed_anything)
		    strlcat(nbuf, ", ", nbufsize);
		s = strlen(nbuf);
		snprintf(nbuf+s, nbufsize-s, "%d %s",
			yar, (yar==1) ? "yard" : "yards");
		printed_anything = True;
	    }
	    if (inr >= FOOT) {
		ft = inr/FOOT;
		inr  %= FOOT;
		if (printed_anything)
		    strlcat(nbuf, ", ", nbufsize);
		s = strlen(nbuf);
		snprintf(nbuf+s, nbufsize-s, "%d %s",
			ft, (ft==1) ? "foot" : "feet");
		printed_anything = True;
	    }
	    if (!printed_anything || inch_frac != 0.0 || inr != 0) {
		if (printed_anything)
		    strlcat(nbuf, ", ", nbufsize);
		s = strlen(nbuf);		
		snprintf(nbuf+s, nbufsize-s, "%.2f inches", inr+inch_frac);
	    }
	}
	strlcat (nbuf, ")", nbufsize);
    }
    return(nbuf);
}	  
  
static char xbuf[BUFSIZ];
static char *
xscale(int x)
{
  if(!xp) {
    scale_init();
  }
  return(nscale(x, xp, xmm, xbuf, sizeof(xbuf)));
}

static char ybuf[BUFSIZ];
static char *
yscale(int y)
{
  if(!yp) {
    scale_init();
  }
  return(nscale(y, yp, ymm, ybuf, sizeof(ybuf)));
}

static char bbuf[BUFSIZ];
static char *
bscale(int b)
{
  if(!bp) {
    scale_init();
  }
  return(nscale(b, bp, bmm, bbuf, sizeof(bbuf)));
}

/* end of pixel to inch, metric converter */

/* This handler is enabled when we are checking
   to see if the -id the user specified is valid. */

/* ARGSUSED */
static int
bad_window_handler(Display *disp, XErrorEvent *err)
{
    char badid[20];

    snprintf(badid, sizeof(badid), window_id_format, err->resourceid);
    Fatal_Error("No such window with id %s.", badid);
    exit (1);
    return 0;
}


int
main(int argc, char **argv)
{
  register int i;
  int tree = 0, stats = 0, bits = 0, events = 0, wm = 0, size  = 0, shape = 0;
  int frame = 0, children = 0;
  Window window;

  INIT_NAME;

#ifndef NO_I18N
  {
     char *lc;
     lc = setlocale(LC_ALL, "");
     if(!lc)
        fprintf(stderr, "can not set locale properly\n");
  }
#endif

  /* Open display, handle command line arguments */
  Setup_Display_And_Screen(&argc, argv);

  /* Get window selected on command line, if any */
  window = Select_Window_Args(&argc, argv);

  /* Handle our command line arguments */
  for (i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-help"))
      usage();
    if (!strcmp(argv[i], "-int")) {
      window_id_format = "%ld";
      continue;
    }
    if (!strcmp(argv[i], "-children")) {
      children = 1;
      continue;
    }
    if (!strcmp(argv[i], "-tree")) {
      tree = 1;
      continue;
    }
    if (!strcmp(argv[i], "-stats")) {
      stats = 1;
      continue;
    }
    if (!strcmp(argv[i], "-bits")) {
      bits = 1;
      continue;
    }
    if (!strcmp(argv[i], "-events")) {
      events = 1;
      continue;
    }
    if (!strcmp(argv[i], "-wm")) {
      wm = 1;
      continue;
    }
    if (!strcmp(argv[i], "-frame")) {
      frame = 1;
      continue;
    }
    if (!strcmp(argv[i], "-size")) {
      size = 1;
      continue;
    }
    if (!strcmp(argv[i], "-shape")) {
      shape = 1;
      continue;
    }
    if (!strcmp(argv[i], "-english")) {
      english = 1;
      continue;
    }
    if (!strcmp(argv[i], "-metric")) {
      metric = 1;
      continue;
    }
    if (!strcmp(argv[i], "-all")) {
      tree = stats = bits = events = wm = size = shape = 1;
      continue;
    }
    usage();
  }

  /* If no window selected on command line, let user pick one the hard way */
  if (!window) {
	  printf("\n");
	  printf("xwininfo: Please select the window about which you\n");
	  printf("          would like information by clicking the\n");
	  printf("          mouse in that window.\n");
	  window = Select_Window(dpy, !frame);
  }

  /*
   * Do the actual displaying as per parameters
   */
  if (!(children || tree || bits || events || wm || size))
    stats = 1;

  /*
   * make sure that the window is valid
   */
  {
    Window root;
    int x, y;
    unsigned width, height, bw, depth;
    XErrorHandler old_handler;

    old_handler = XSetErrorHandler(bad_window_handler);
    XGetGeometry (dpy, window, &root, &x, &y, &width, &height, &bw, &depth);
    XSync (dpy, False);
    (void) XSetErrorHandler(old_handler);
  }

  printf("\nxwininfo: Window id: ");
  Display_Window_Id(window, True);
  if (children || tree)
    Display_Tree_Info(window, tree);
  if (stats)
    Display_Stats_Info(window);
  if (bits)
    Display_Bits_Info(window);
  if (events)
    Display_Events_Info(window);
  if (wm)
    Display_WM_Info(window);
  if (size)
    Display_Size_Hints(window);
  if (shape)
    Display_Window_Shape(window);
  printf("\n");
  exit(0);
}


/*
 * Lookup: lookup a code in a table.
 */
static char _lookup_buffer[100];

static const char *
LookupL(long code, const binding *table)
{
	const char *name;

	snprintf(_lookup_buffer, sizeof(_lookup_buffer),
		 "unknown (code = %ld. = 0x%lx)", code, code);
	name = _lookup_buffer;

	while (table->name) {
		if (table->code == code) {
			name = table->name;
			break;
		}
		table++;
	}

	return(name);
}

static const char *
Lookup(int code, const binding *table)
{
    return LookupL((long)code, table);
}

/*
 * Routine to display a window id in dec/hex with name if window has one
 */

static void
Display_Window_Id(Window window, Bool newline_wanted)
{
#ifdef NO_I18N
    char *win_name;
#else
    XTextProperty tp;
#endif
    
    printf(window_id_format, window);         /* print id # in hex/dec */

    if (!window) {
	printf(" (none)");
    } else {
	if (window == RootWindow(dpy, screen)) {
	    printf(" (the root window)");
	}
#ifdef NO_I18N
	if (!XFetchName(dpy, window, &win_name)) { /* Get window name if any */
	    printf(" (has no name)");
	} else if (win_name) {
	    printf(" \"%s\"", win_name);
	    XFree(win_name);
	}
#else
	if (!XGetWMName(dpy, window, &tp)) { /* Get window name if any */
	    printf(" (has no name)");
        } else if (tp.nitems > 0) {
            printf(" \"");
            {
                int count = 0, i, ret;
                char **list = NULL;
                ret = XmbTextPropertyToTextList(dpy, &tp, &list, &count);
                if((ret == Success || ret > 0) && list != NULL){
                    for(i=0; i<count; i++)
                        printf("%s", list[i]);
                    XFreeStringList(list);
                } else {
                    printf("%s", tp.value);
                }
            }
            printf("\"");
	}
#endif
	else
	    printf(" (has no name)");
    }

    if (newline_wanted)
	printf("\n");

    return;
}


/*
 * Display Stats on window
 */
static const binding _window_classes[] = {
	{ InputOutput, "InputOutput" },
	{ InputOnly, "InputOnly" },
        { 0, 0 } };

static const binding _map_states[] = {
	{ IsUnmapped, "IsUnMapped" },
	{ IsUnviewable, "IsUnviewable" },
	{ IsViewable, "IsViewable" },
	{ 0, 0 } };

static const binding _backing_store_states[] = {
	{ NotUseful, "NotUseful" },
	{ WhenMapped, "WhenMapped" },
	{ Always, "Always" },
	{ 0, 0 } };

static const binding _bit_gravity_states[] = {
	{ ForgetGravity, "ForgetGravity" },
	{ NorthWestGravity, "NorthWestGravity" },
	{ NorthGravity, "NorthGravity" },
	{ NorthEastGravity, "NorthEastGravity" },
	{ WestGravity, "WestGravity" },
	{ CenterGravity, "CenterGravity" },
	{ EastGravity, "EastGravity" },
	{ SouthWestGravity, "SouthWestGravity" },
	{ SouthGravity, "SouthGravity" },
	{ SouthEastGravity, "SouthEastGravity" },
	{ StaticGravity, "StaticGravity" },
	{ 0, 0 }};

static const binding _window_gravity_states[] = {
	{ UnmapGravity, "UnmapGravity" },
	{ NorthWestGravity, "NorthWestGravity" },
	{ NorthGravity, "NorthGravity" },
	{ NorthEastGravity, "NorthEastGravity" },
	{ WestGravity, "WestGravity" },
	{ CenterGravity, "CenterGravity" },
	{ EastGravity, "EastGravity" },
	{ SouthWestGravity, "SouthWestGravity" },
	{ SouthGravity, "SouthGravity" },
	{ SouthEastGravity, "SouthEastGravity" },
	{ StaticGravity, "StaticGravity" },
	{ 0, 0 }};

static const binding _visual_classes[] = {
	{ StaticGray, "StaticGray" },
	{ GrayScale, "GrayScale" },
	{ StaticColor, "StaticColor" },
	{ PseudoColor, "PseudoColor" },
	{ TrueColor, "TrueColor" },
	{ DirectColor, "DirectColor" },
	{ 0, 0 }};

static void
Display_Stats_Info(Window window)
{
  XWindowAttributes win_attributes;
  XVisualInfo vistemplate, *vinfo;
  XSizeHints hints;
  int dw = DisplayWidth (dpy, screen), dh = DisplayHeight (dpy, screen);
  int rx, ry, xright, ybelow;
  int showright = 0, showbelow = 0;
  Status status;
  Window wmframe;
  int junk;
  long longjunk;
  Window junkwin;

  if (!XGetWindowAttributes(dpy, window, &win_attributes))
    Fatal_Error("Can't get window attributes.");
  vistemplate.visualid = XVisualIDFromVisual(win_attributes.visual);
  vinfo = XGetVisualInfo(dpy, VisualIDMask, &vistemplate, &junk);

  (void) XTranslateCoordinates (dpy, window, win_attributes.root, 
				-win_attributes.border_width,
				-win_attributes.border_width,
				&rx, &ry, &junkwin);
				
  xright = (dw - rx - win_attributes.border_width * 2 -
	    win_attributes.width);
  ybelow = (dh - ry - win_attributes.border_width * 2 -
	    win_attributes.height);

  printf("\n");
  printf("  Absolute upper-left X:  %s\n", xscale(rx));
  printf("  Absolute upper-left Y:  %s\n", yscale(ry));
  printf("  Relative upper-left X:  %s\n", xscale(win_attributes.x));
  printf("  Relative upper-left Y:  %s\n", yscale(win_attributes.y));
  printf("  Width: %s\n", xscale(win_attributes.width));
  printf("  Height: %s\n", yscale(win_attributes.height));
  printf("  Depth: %d\n", win_attributes.depth);
  printf("  Visual Class: %s\n", Lookup(vinfo->class, _visual_classes));
  printf("  Border width: %s\n", bscale(win_attributes.border_width));
  printf("  Class: %s\n",
  	 Lookup(win_attributes.class, _window_classes));
  printf("  Colormap: 0x%lx (%sinstalled)\n", 
	 win_attributes.colormap, win_attributes.map_installed ? "" : "not ");
  printf("  Bit Gravity State: %s\n",
  	 Lookup(win_attributes.bit_gravity, _bit_gravity_states));
  printf("  Window Gravity State: %s\n",
  	 Lookup(win_attributes.win_gravity, _window_gravity_states));
  printf("  Backing Store State: %s\n",
  	 Lookup(win_attributes.backing_store, _backing_store_states));
  printf("  Save Under State: %s\n",
  	 win_attributes.save_under ? "yes" : "no");
  printf("  Map State: %s\n",
	 Lookup(win_attributes.map_state, _map_states));
  printf("  Override Redirect State: %s\n",
  	 win_attributes.override_redirect ? "yes" : "no");
  printf("  Corners:  +%d+%d  -%d+%d  -%d-%d  +%d-%d\n",
	 rx, ry, xright, ry, xright, ybelow, rx, ybelow);

  XFree(vinfo);

  /*
   * compute geometry string that would recreate window
   */
  printf("  -geometry ");

  /* compute size in appropriate units */
  status = XGetWMNormalHints(dpy, window, &hints, &longjunk);
  if (status  &&  hints.flags & PResizeInc  &&
              hints.width_inc != 0  &&  hints.height_inc != 0) {
      if (hints.flags & (PBaseSize|PMinSize)) {
	  if (hints.flags & PBaseSize) {
	      win_attributes.width -= hints.base_width;
	      win_attributes.height -= hints.base_height;
	  } else {
	      /* ICCCM says MinSize is default for BaseSize */
	      win_attributes.width -= hints.min_width;
	      win_attributes.height -= hints.min_height;
	  }
      }
      printf("%dx%d", win_attributes.width/hints.width_inc,
	     win_attributes.height/hints.height_inc);
  } else
      printf("%dx%d", win_attributes.width, win_attributes.height);

  if (!(hints.flags&PWinGravity))
      hints.win_gravity = NorthWestGravity; /* per ICCCM */
  /* find our window manager frame, if any */
  wmframe = window;
  while (True) {
      Window root, parent;
      Window *childlist;
      unsigned int ujunk;

      status = XQueryTree(dpy, wmframe, &root, &parent, &childlist, &ujunk);
      if (parent == root || !parent || !status)
	  break;
      wmframe = parent;
      if (status && childlist)
	  XFree((char *)childlist);
  }
  if (wmframe != window) {
      /* WM reparented, so find edges of the frame */
      /* Only works for ICCCM-compliant WMs, and then only if the
         window has corner gravity.  We would need to know the original width
	 of the window to correctly handle the other gravities. */

      XWindowAttributes frame_attr;

      if (!XGetWindowAttributes(dpy, wmframe, &frame_attr))
	  Fatal_Error("Can't get frame attributes.");
      switch (hints.win_gravity) {
	case NorthWestGravity: case SouthWestGravity:
	case NorthEastGravity: case SouthEastGravity:
	case WestGravity:
	  rx = frame_attr.x;
      }
      switch (hints.win_gravity) {
	case NorthWestGravity: case SouthWestGravity:
	case NorthEastGravity: case SouthEastGravity:
	case EastGravity:
	  xright = dw - frame_attr.x - frame_attr.width -
	      2*frame_attr.border_width;
      }
      switch (hints.win_gravity) {
	case NorthWestGravity: case SouthWestGravity:
	case NorthEastGravity: case SouthEastGravity:
	case NorthGravity:
	  ry = frame_attr.y;
      }
      switch (hints.win_gravity) {
	case NorthWestGravity: case SouthWestGravity:
	case NorthEastGravity: case SouthEastGravity:
	case SouthGravity:
	  ybelow = dh - frame_attr.y - frame_attr.height -
	      2*frame_attr.border_width;
      }
  }
  /* If edge gravity, offer a corner on that edge (because the application
     programmer cares about that edge), otherwise offer upper left unless
     some other corner is close to an edge of the screen.
     (For corner gravity, assume gravity was set by XWMGeometry.
     For CenterGravity, it doesn't matter.) */
  if (hints.win_gravity == EastGravity  ||
      (abs(xright) <= 100  &&  abs(xright) < abs(rx)
        &&  hints.win_gravity != WestGravity))
      showright = 1;
  if (hints.win_gravity == SouthGravity  ||
      (abs(ybelow) <= 100  &&  abs(ybelow) < abs(ry)
        &&  hints.win_gravity != NorthGravity))
      showbelow = 1;
  
  if (showright)
      printf("-%d", xright);
  else
      printf("+%d", rx);
  if (showbelow)
      printf("-%d", ybelow);
  else
      printf("+%d", ry);
  printf("\n");
}


/*
 * Display bits info:
 */
static const binding _gravities[] = {
	{ UnmapGravity, "UnMapGravity" },      /* WARNING: both of these have*/
	{ ForgetGravity, "ForgetGravity" },    /* the same value - see code */
	{ NorthWestGravity, "NorthWestGravity" },
	{ NorthGravity, "NorthGravity" },
	{ NorthEastGravity, "NorthEastGravity" },
	{ WestGravity, "WestGravity" },
	{ CenterGravity, "CenterGravity" },
	{ EastGravity, "EastGravity" },
	{ SouthWestGravity, "SouthWestGravity" },
	{ SouthGravity, "SouthGravity" },
	{ SouthEastGravity, "SouthEastGravity" },
	{ StaticGravity, "StaticGravity" },
	{ 0, 0 } };

static const binding _backing_store_hint[] = {
	{ NotUseful, "NotUseful" },
	{ WhenMapped, "WhenMapped" },
	{ Always, "Always" },
	{ 0, 0 } };

static const binding _bool[] = {
	{ 0, "No" },
	{ 1, "Yes" },
	{ 0, 0 } };

static void
Display_Bits_Info(Window window)
{
  XWindowAttributes win_attributes;

  if (!XGetWindowAttributes(dpy, window, &win_attributes))
    Fatal_Error("Can't get window attributes.");

  printf("\n");
  printf("  Bit gravity: %s\n",
	 Lookup(win_attributes.bit_gravity, _gravities+1));
  printf("  Window gravity: %s\n",
	 Lookup(win_attributes.win_gravity, _gravities));
  printf("  Backing-store hint: %s\n",
	 Lookup(win_attributes.backing_store, _backing_store_hint));
  printf("  Backing-planes to be preserved: 0x%lx\n",
	 win_attributes.backing_planes);
  printf("  Backing pixel: %ld\n", win_attributes.backing_pixel);
  printf("  Save-unders: %s\n",
	 Lookup(win_attributes.save_under, _bool));
}


/*
 * Routine to display all events in an event mask
 */
static const binding _event_mask_names[] = {
	{ KeyPressMask, "KeyPress" },
	{ KeyReleaseMask, "KeyRelease" },
	{ ButtonPressMask, "ButtonPress" },
	{ ButtonReleaseMask, "ButtonRelease" },
	{ EnterWindowMask, "EnterWindow" },
	{ LeaveWindowMask, "LeaveWindow" },
	{ PointerMotionMask, "PointerMotion" },
	{ PointerMotionHintMask, "PointerMotionHint" },
	{ Button1MotionMask, "Button1Motion" },
	{ Button2MotionMask, "Button2Motion" },
	{ Button3MotionMask, "Button3Motion" },
	{ Button4MotionMask, "Button4Motion" },
	{ Button5MotionMask, "Button5Motion" },
	{ ButtonMotionMask, "ButtonMotion" },
	{ KeymapStateMask, "KeymapState" },
	{ ExposureMask, "Exposure" },
	{ VisibilityChangeMask, "VisibilityChange" },
	{ StructureNotifyMask, "StructureNotify" },
	{ ResizeRedirectMask, "ResizeRedirect" },
	{ SubstructureNotifyMask, "SubstructureNotify" },
	{ SubstructureRedirectMask, "SubstructureRedirect" },
	{ FocusChangeMask, "FocusChange" },
	{ PropertyChangeMask, "PropertyChange" },
	{ ColormapChangeMask, "ColormapChange" },
	{ OwnerGrabButtonMask, "OwnerGrabButton" },
	{ 0, 0 } };

static void
Display_Event_Mask(long mask)
{
  long bit, bit_mask;

  for (bit=0, bit_mask=1; bit<sizeof(long)*8; bit++, bit_mask <<= 1)
    if (mask & bit_mask)
      printf("      %s\n",
	     LookupL(bit_mask, _event_mask_names));
}


/*
 * Display info on events
 */
static void
Display_Events_Info(Window window)
{
  XWindowAttributes win_attributes;

  if (!XGetWindowAttributes(dpy, window, &win_attributes))
    Fatal_Error("Can't get window attributes.");

  printf("\n");
  printf("  Someone wants these events:\n");
  Display_Event_Mask(win_attributes.all_event_masks);

  printf("  Do not propagate these events:\n");
  Display_Event_Mask(win_attributes.do_not_propagate_mask);

  printf("  Override redirection?: %s\n",
	 Lookup(win_attributes.override_redirect, _bool));
}


  /* left out visual stuff */
  /* left out colormap */
  /* left out map_installed */


/*
 * Display root, parent, and (recursively) children information
 * recurse - true to show children information
 */
static void
Display_Tree_Info(Window window, int recurse)
{
    display_tree_info_1(window, recurse, 0);
}

/*
 * level - recursion level
 */
static void
display_tree_info_1(Window window, int recurse, int level)
{
  int i, j;
  int rel_x, rel_y, abs_x, abs_y;
  unsigned int width, height, border, depth;
  Window root_win, parent_win;
  unsigned int num_children;
  Window *child_list;
  XClassHint classhint;

  if (!XQueryTree(dpy, window, &root_win, &parent_win, &child_list,
		  &num_children))
    Fatal_Error("Can't query window tree.");

  if (level == 0) {
    printf("\n");
    printf("  Root window id: ");
    Display_Window_Id(root_win, True);
    printf("  Parent window id: ");
    Display_Window_Id(parent_win, True);
  }

  if (level == 0  ||  num_children > 0) {
    printf("     ");
    for (j=0; j<level; j++) printf("   ");
    printf("%d child%s%s\n", num_children, num_children == 1 ? "" : "ren",
	   num_children ? ":" : ".");
  }

  for (i = (int)num_children - 1; i >= 0; i--) {
    printf("     ");
    for (j=0; j<level; j++) printf("   ");
    Display_Window_Id(child_list[i], False);
    printf(": (");
    if(XGetClassHint(dpy, child_list[i], &classhint)) {
	if(classhint.res_name) {
	    printf("\"%s\" ", classhint.res_name);
	    XFree(classhint.res_name);
	} else
	    printf("(none) ");
	if(classhint.res_class) {
	    printf("\"%s\") ", classhint.res_class);
	    XFree(classhint.res_class);
	} else
	    printf("(none)) ");
    } else
	printf(") ");

    if (XGetGeometry(dpy, child_list[i], &root_win,
		     &rel_x, &rel_y, &width, &height, &border, &depth)) {
	Window child;

	printf (" %ux%u+%d+%d", width, height, rel_x, rel_y);
	if (XTranslateCoordinates (dpy, child_list[i], root_win,
				   0 ,0, &abs_x, &abs_y, &child)) {
	    printf ("  +%d+%d", abs_x - border, abs_y - border);
	}
    }
    printf("\n");
    
    if (recurse)
	display_tree_info_1(child_list[i], 1, level+1);
  }

  if (child_list) XFree((char *)child_list);
}


/*
 * Display a set of size hints
 */
static void
Display_Hints(XSizeHints *hints)
{
	long flags;

	flags = hints->flags;
	
	if (flags & USPosition)
	  printf("      User supplied location: %s, %s\n",
		 xscale(hints->x), yscale(hints->y));

	if (flags & PPosition)
	  printf("      Program supplied location: %s, %s\n",
		 xscale(hints->x), yscale(hints->y));

	if (flags & USSize) {
	  printf("      User supplied size: %s by %s\n",
		 xscale(hints->width), yscale(hints->height));
	}

	if (flags & PSize)
	  printf("      Program supplied size: %s by %s\n",
		 xscale(hints->width), yscale(hints->height));

	if (flags & PMinSize)
	  printf("      Program supplied minimum size: %s by %s\n",
		 xscale(hints->min_width), yscale(hints->min_height));

	if (flags & PMaxSize)
	  printf("      Program supplied maximum size: %s by %s\n",
		 xscale(hints->max_width), yscale(hints->max_height));

	if (flags & PBaseSize) {
	  printf("      Program supplied base size: %s by %s\n",
		 xscale(hints->base_width), yscale(hints->base_height));
	}

	if (flags & PResizeInc) {
	  printf("      Program supplied x resize increment: %s\n",
		 xscale(hints->width_inc));
	  printf("      Program supplied y resize increment: %s\n",
		 yscale(hints->height_inc));
	  if (hints->width_inc != 0 && hints->height_inc != 0) {
	      if (flags & USSize)
		  printf("      User supplied size in resize increments:  %s by %s\n",
			 (xscale(hints->width / hints->width_inc)), 
			 (yscale(hints->height / hints->height_inc)));
	      if (flags & PSize)
		  printf("      Program supplied size in resize increments:  %s by %s\n",
			 (xscale(hints->width / hints->width_inc)), 
			 (yscale(hints->height / hints->height_inc)));
	      if (flags & PMinSize)
		  printf("      Program supplied minimum size in resize increments: %s by %s\n",
			 xscale(hints->min_width / hints->width_inc), yscale(hints->min_height / hints->height_inc));
	      if (flags & PBaseSize)
		  printf("      Program supplied base size in resize increments:  %s by %s\n",
			 (xscale(hints->base_width / hints->width_inc)), 
			 (yscale(hints->base_height / hints->height_inc)));
	  }
        }

	if (flags & PAspect) {
	  printf("      Program supplied min aspect ratio: %s/%s\n",
		 xscale(hints->min_aspect.x), yscale(hints->min_aspect.y));
	  printf("      Program supplied max aspect ratio: %s/%s\n",
		 xscale(hints->max_aspect.x), yscale(hints->max_aspect.y));
        }

	if (flags & PWinGravity) {
	  printf("      Program supplied window gravity: %s\n",
		 Lookup(hints->win_gravity, _gravities));
	}
}


/*
 * Display Size Hints info
 */
static void
Display_Size_Hints(Window window)
{
	XSizeHints *hints = XAllocSizeHints();
	long supplied;

	printf("\n");
	if (!XGetWMNormalHints(dpy, window, hints, &supplied))
	    printf("  No normal window size hints defined\n");
	else {
	    printf("  Normal window size hints:\n");
	    hints->flags &= supplied;
	    Display_Hints(hints);
	}

	if (!XGetWMSizeHints(dpy, window, hints, &supplied, XA_WM_ZOOM_HINTS))
	    printf("  No zoom window size hints defined\n");
	else {
	    printf("  Zoom window size hints:\n");
	    hints->flags &= supplied;
	    Display_Hints(hints);
	}
	XFree((char *)hints);
}


static void
Display_Window_Shape (Window window)
{
    Bool    ws, bs;
    int	    xws, yws, xbs, ybs;
    unsigned int wws, hws, wbs, hbs;

    if (!XShapeQueryExtension (dpy, &bs, &ws))
	return;

    printf("\n");
    XShapeQueryExtents (dpy, window, &ws, &xws, &yws, &wws, &hws,
				     &bs, &xbs, &ybs, &wbs, &hbs);
    if (!ws)
	  printf("  No window shape defined\n");
    else {
	  printf("  Window shape extents:  %sx%s",
		 xscale(wws), yscale(hws));
	  printf("+%s+%s\n", xscale(xws), yscale(yws));
    }
    if (!bs)
	  printf("  No border shape defined\n");
    else {
	  printf("  Border shape extents:  %sx%s",
		 xscale(wbs), yscale(hbs));
	  printf("+%s+%s\n", xscale(xbs), yscale(ybs));
    }
}

/*
 * Display Window Manager Info
 */
static const binding _state_hints[] = {
	{ DontCareState, "Don't Care State" },
	{ NormalState, "Normal State" },
	{ ZoomState, "Zoomed State" },
	{ IconicState, "Iconic State" },
	{ InactiveState, "Inactive State" },
	{ 0, 0 } };

static void
Display_WM_Info(Window window)
{
        XWMHints *wmhints;
	long flags;

	wmhints = XGetWMHints(dpy, window);
	printf("\n");
	if (!wmhints) {
		printf("  No window manager hints defined\n");
		return;
	}
	flags = wmhints->flags;

	printf("  Window manager hints:\n");

	if (flags & InputHint)
	  printf("      Client accepts input or input focus: %s\n",
		 Lookup(wmhints->input, _bool));

	if (flags & IconWindowHint) {
		printf("      Icon window id: ");
		Display_Window_Id(wmhints->icon_window, True);
	}

	if (flags & IconPositionHint)
	  printf("      Initial icon position: %s, %s\n",
		 xscale(wmhints->icon_x), yscale(wmhints->icon_y));

	if (flags & StateHint)
	  printf("      Initial state is %s\n",
		 Lookup(wmhints->initial_state, _state_hints));

	XFree(wmhints);
}

--0F1p//8PRICkK4MW
Content-Type: application/x-sh
Content-Disposition: attachment; filename="test.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0A=0ANUM_WRITES=3D`strace ./xwininfo -root -tree 2>&1 | grep w=
ritev | wc -l`=0ASTART_CTXT=3D`grep ctxt /proc/stat`=0A./xwininfo -root -tr=
ee=0AEND_CTXT=3D`grep ctxt /proc/stat`=0A=0ASTART=3D$(echo $START_CTXT | aw=
k '{ print $2; }')=0AEND=3D$(echo $END_CTXT | awk '{ print $2; }')=0A=0ATOT=
AL=3D`expr $END - $START`=0A=0Aecho number of writes: $NUM_WRITES contex sw=
itches: $TOTAL per write `expr $TOTAL / $NUM_WRITES` modulo `expr $TOTAL % =
$NUM_WRITES` =0A=0Aif [ `expr $TOTAL / $NUM_WRITES` -ge 3 ]; then=0A	echo F=
AIL=0A	return 1=0Afi=0Aecho PASS=0Areturn 0=0A
--0F1p//8PRICkK4MW--
